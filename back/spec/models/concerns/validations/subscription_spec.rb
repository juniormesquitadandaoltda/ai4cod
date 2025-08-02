require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe '.after_commit' do
    describe 'on create' do
      subject { build(:subscription) }

      after { subject.save! }

      it { is_expected.to receive(:after_create_fields!) }
    end

    describe 'on update' do
      subject { create(:subscription) }

      after { subject.save! }

      it { is_expected.not_to receive(:after_create_fields!) }
    end
  end

  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }

    it { expect(create(:subscription)).to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  end

  describe '#user' do
    it { is_expected.to validate_presence_of(:user) }

    it { expect(create(:subscription)).to validate_persistence_of(:user) }

    it { expect(create(:subscription)).to validate_unchange_of(:user) }

    it '#validate_user_profile' do
      subject.user = build(:user, :admin)

      subject.valid?

      expect(subject.errors.details[:user]).to be_include(error: :invalid_profile)
    end
  end

  describe '#due_date' do
    it { is_expected.to validate_presence_of(:due_date) }
  end

  describe '#current_records_count' do
    it { is_expected.to validate_presence_of(:current_records_count) }

    it { expect(build(:subscription)).to validate_numericality_of(:current_records_count).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(1_000) }
  end

  describe '#maximum_records_count' do
    it 'must be present' do
      subject.current_records_count = nil

      subject.valid?

      expect(subject.errors.details[:current_records_count]).to be_include(error: :blank)
    end

    it { is_expected.to validate_numericality_of(:maximum_records_count).is_greater_than_or_equal_to(0) }
  end

  describe '#actived' do
    it { is_expected.not_to validate_presence_of(:actived) }
  end

  it '#expired?' do
    subject.due_date = Date.current.yesterday
    expect(subject).to be_expired

    subject.due_date = Date.current
    expect(subject).not_to be_expired

    subject.due_date = Date.current.tomorrow
    expect(subject).not_to be_expired
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[name])
  end

  describe '#counters' do
    it { expect(subject.current_records_count).to eq(0) }
    it { expect(subject.maximum_records_count).to eq(0) }
    it { expect(subject.collaborators_count).to eq(0) }
    it { expect(subject.webhooks_count).to eq(0) }
    it { expect(subject.calleds_count).to eq(0) }
    it { expect(subject.fields_count).to eq(0) }
    it { expect(subject.proprietors_count).to eq(0) }
    it { expect(subject.facilitators_count).to eq(0) }
    it { expect(subject.vehicles_count).to eq(0) }
    it { expect(subject.tasks_count).to eq(0) }
  end

  it '#after_create_fields!' do
    subject.id = 1
    PaperTrail.request.whodunnit = build(:user)

    expect(::STANDARD::SubscriptionsJob).to receive(:perform).with(subscription: subject, whodunnit: PaperTrail.request.whodunnit)

    subject.send(:after_create_fields!)
  end

  it '.counts' do
    expect(described_class.counts).to eq(
      %i[
        archives_count
        calleds_count
        collaborators_count
        facilitators_count
        fields_count
        proprietors_count
        tasks_count
        vehicles_count
        webhooks_count
      ]
    )
  end
end
