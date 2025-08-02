require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#stage' do
    it { is_expected.to validate_presence_of(:stage) }
    it { expect(create(:task)).to validate_field_enum_of(:stage) }
  end

  describe '#next_stage' do
    it { is_expected.not_to validate_presence_of(:next_stage) }
    it { expect(create(:task)).to validate_field_enum_of(:next_stage) }
  end

  describe '#scheduling_at' do
    it { is_expected.not_to validate_presence_of(:scheduling_at) }
    it { is_expected.to validate_datetime_of(:scheduling_at).allow_nil }
  end

  describe '#notes' do
    it { is_expected.not_to validate_presence_of(:notes) }
    it { is_expected.to validate_length_of(:notes).is_at_most(1024) }
  end

  describe '#shared' do
    it { is_expected.not_to validate_presence_of(:shared) }
  end

  describe '#vehicle' do
    it { is_expected.to validate_presence_of(:vehicle) }
    it { expect(create(:task)).to validate_persistence_of(:vehicle) }
  end

  describe '#facilitator' do
    it { is_expected.not_to validate_presence_of(:facilitator) }
    it { expect(create(:task)).to validate_persistence_of(:facilitator) }
  end

  describe '#proprietor' do
    it { is_expected.not_to validate_presence_of(:proprietor) }
    it { expect(create(:task)).to validate_persistence_of(:proprietor) }
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }
    it { expect(create(:task)).to validate_persistence_of(:subscription) }
    it { expect(create(:task)).to validate_unchange_of(:subscription) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[name])
  end
end
