require 'rails_helper'

RSpec.describe Archive, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Validations::ApplicationRecord) }
  end

  describe '.custom_create' do
    it 'must be current' do
      task = create(:task)
      expect(SecureRandom).to receive(:base58).with(28).and_return('token')

      instance = described_class.custom_create(
        filename: 'Name.txt',
        base64: 'base64',
        record: {
          id: task.id,
          type: 'Task'
        },
        subscription: {
          id: task.subscription.id
        }
      )

      expect(instance).to be_is_a(described_class)
      expect(instance.reload.attributes).to include_json(
        name: 'archives',
        record_type: 'Task',
        record_id: task.id,
        subscription_id: task.subscription.id
      )
      expect(instance.blob.attributes).to include_json(
        filename: 'Name.txt',
        searchable_filename: 'name.txt',
        service_name: 'test',
        key: 'test/storage/token',
        metadata: {
          identified: true,
          analyzed: true
        }
      )
    end

    it 'must be standard' do
      instance = described_class.custom_create

      expect(instance).to be_is_a(described_class)
      expect(instance.errors.details[:record]).to include(error: :blank)
    end
  end

  describe '.before_validation' do
    describe 'on create' do
      subject { build(:archive) }

      after { subject.save }

      it { is_expected.to receive(:config_subscription!) }
    end

    describe 'on update' do
      subject { create(:archive) }

      after { subject.save }

      it { is_expected.not_to receive(:config_subscription!) }
    end
  end

  describe '#url' do
    it { is_expected.to delegate_method(:url).to(:blob).allow_nil }
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }

    it { expect(create(:archive)).to validate_persistence_of(:subscription) }

    it { expect(create(:archive)).to validate_unchange_of(:subscription) }
  end

  describe '#record' do
    it { is_expected.to validate_presence_of(:record) }

    it { expect(create(:archive)).to validate_persistence_of(:record) }

    it { expect(create(:archive)).to validate_unchange_of(:record) }
  end

  it 'destroy' do
    instance = create(:archive)

    instance.record.update!(updated_at: 1.day.ago)

    expect { instance.destroy }.not_to change(instance.record, :updated_at)
  end

  describe '#filename' do
    it { is_expected.to validate_presence_of(:filename) }

    it 'must be current' do
      subject.assign_attributes(
        blob: ActiveStorage::Blob.new(filename: 'name_1.txt'),
        filename: 'name_2.txt'
      )

      expect(subject.filename).to eq('name_2.txt')
      expect(subject.blob.filename.to_s).to eq('name_2.txt')
    end
  end

  describe '#byte_size' do
    it 'must be current' do
      subject.assign_attributes(
        blob: ActiveStorage::Blob.new(filename: 'name_1.txt', byte_size: 10)
      )

      expect(subject.byte_size).to eq(10)
    end
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[record_type])
  end

  describe '#config_subscription!' do
    it 'must be current' do
      subject.record = build(:called)

      expect(subject).to receive(:before_validation_subscription_current_records_count!)
      expect(subject).to receive(:before_validation_subscription_due_date!)

      subject.send(:config_subscription!)

      expect(subject.subscription).to eq(subject.record.subscription)
    end

    it 'must be standard' do
      subject.send(:config_subscription!)

      expect(subject.subscription).to be_nil
    end
  end
end
