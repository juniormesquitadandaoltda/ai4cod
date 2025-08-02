require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.enum' do
    it {
      expect(subject).to define_enum_for(:timezone).with_values(
        %i[UTC Brasilia].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }

    it {
      expect(subject).to define_enum_for(:locale).with_values(
        %i[en pt-BR].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }

    it {
      expect(subject).to define_enum_for(:status).with_values(
        %i[created destroyed].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }

    it {
      expect(subject).to define_enum_for(:profile).with_values(
        %i[standard admin].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }
  end

  describe '.before_validation' do
    describe 'on create' do
      after { subject.save }

      it { is_expected.to receive(:config_timezone!) }
      it { is_expected.to receive(:config_locale!) }
      it { is_expected.to receive(:config_status!) }
      it { is_expected.to receive(:config_profile!) }
      it { is_expected.to receive(:config_password!) }
      it { is_expected.to receive(:config_access_sent_at!) }
    end

    describe 'on update' do
      subject { create(:user) }

      after { subject.save }

      it { is_expected.not_to receive(:config_timezone!) }
      it { is_expected.not_to receive(:config_locale!) }
      it { is_expected.not_to receive(:config_status!) }
      it { is_expected.not_to receive(:config_profile!) }
      it { is_expected.not_to receive(:config_password!) }
      it { is_expected.not_to receive(:config_access_sent_at!) }
    end
  end

  describe '#name' do
    before { allow(subject).to receive(:config_name!) }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#timezone' do
    before { allow(subject).to receive(:config_timezone!) }

    it { is_expected.to validate_presence_of(:timezone) }
    it { expect(create(:user)).to validate_enum_of(:timezone) }
  end

  describe '#locale' do
    before { allow(subject).to receive(:config_locale!) }

    it { is_expected.to validate_presence_of(:locale) }
    it { expect(create(:user)).to validate_enum_of(:locale) }
  end

  describe '#status' do
    before { allow(subject).to receive(:config_status!) }

    it { is_expected.to validate_presence_of(:status) }
    it { expect(create(:user)).to validate_enum_of(:status) }
  end

  describe '#profile' do
    before { allow(subject).to receive(:config_profile!) }

    it { is_expected.to validate_presence_of(:profile) }
    it { expect(create(:user)).to validate_enum_of(:profile) }
  end

  describe '#policy_terms' do
    it { is_expected.to validate_presence_of(:policy_terms) }
  end

  describe '#destroyed_at' do
    it { expect(create(:user, destroyed_at: Time.current)).to validate_unchange_of(:destroyed_at) }
  end

  it '#destroy' do
    Timecop.freeze do
      subject = create(:user)
      email = subject.email

      subject.destroy!

      expect(subject.as_json(only: %i[destroyed_at email status])).to eq({
        destroyed_at: Time.current,
        email: "#{email}.#{Time.current.to_i}",
        status: 'destroyed'
      }.as_json)

      expect { subject.reload.destroy! }.to raise_exception(ActiveRecord::RecordNotDestroyed)
    end
  end

  it '#config_name!' do
    subject.email = 'user-name@email.com'

    subject.send(:config_name!)

    expect(subject.name).to eq('User Name')
  end

  it '#config_timezone!' do
    subject.send(:config_timezone!)
    expect(subject.timezone).to eq('Brasilia')
  end

  it '#config_locale!' do
    subject.send(:config_locale!)
    expect(subject.locale).to eq('pt-BR')
  end

  it '#config_status!' do
    subject.send(:config_status!)
    expect(subject.status).to eq('created')
  end

  it '#config_profile!' do
    subject.send(:config_profile!)
    expect(subject.profile).to eq('standard')
  end

  it '#config_password!' do
    token = Devise.friendly_token(32)

    expect(Devise).to receive(:friendly_token).with(32) { token }
    subject.send(:config_password!)

    expect(subject.password).to eq(token)
    expect(subject.password_confirmation).to eq(token)
  end

  it '#config_access_sent_at!' do
    Timecop.freeze do
      subject.send(:config_access_sent_at!)
      expect(subject.access_sent_at).to eq(Time.current)
    end
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[email name])
  end

  describe '#counters' do
    it { expect(subject.subscriptions_count).to eq(0) }
    it { expect(subject.collaborations_count).to eq(0) }
  end

  describe '#uuid' do
    it { expect(create(:user).reload.uuid).to be_present }
  end

  it '#send_reset_password_instructions' do
    expect(subject).to receive(:send_reset_password_instructions_notification).with(nil)

    subject.send(:send_reset_password_instructions)
  end

  describe '#valid_password' do
    it 'must be false' do
      subject.assign_attributes(email: '@', sign_in_count: 0)
      token = subject.send(:generate_temp_password)

      expect(subject).to be_valid_password(token)

      expect(subject).not_to be_valid_password(token.reverse)
    end
  end

  it '#generate_temp_password' do
    Timecop.freeze do
      subject.assign_attributes(email: '@', sign_in_count: 0)

      expect(subject.send(:generate_temp_password).size).to eq(517)

      expect(SecureRandom).to receive(:base58).with(200).and_return('token')
      expect(ActiveSupport::MessageEncryptor).to receive(:new).with(
        Rails.application.secret_key_base[0...32]
      ).and_call_original
      expect_any_instance_of(ActiveSupport::MessageEncryptor).to receive(:encrypt_and_sign).with(
        'token:@:0', expires_in: 3.minutes
      ).and_return('encrypted_token===---/+')

      expect(subject.send(:generate_temp_password)).to eq('ÉéÁáÇçnekotídetpyrcne')
    end
  end
end
