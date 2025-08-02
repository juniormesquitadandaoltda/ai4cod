require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#chassis' do
    it { is_expected.to validate_presence_of(:chassis) }
    it { expect(create(:vehicle)).to validate_uniqueness_of(:chassis).scoped_to(:subscription_id).case_insensitive }
  end

  describe '#year' do
    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to allow_value('2024/2025').for(:year) }
  end

  describe '#brand' do
    it { is_expected.to validate_presence_of(:brand) }
    it { expect(create(:vehicle)).to validate_field_enum_of(:brand) }
  end

  describe '#model' do
    it { is_expected.to validate_presence_of(:model) }
    it { expect(create(:vehicle)).to validate_field_enum_of(:model) }
  end

  describe '#color' do
    it { is_expected.to validate_presence_of(:color) }
    it { expect(create(:vehicle)).to validate_field_enum_of(:color) }
  end

  describe '#fuel' do
    it { is_expected.to validate_presence_of(:fuel) }
    it { expect(create(:vehicle)).to validate_field_enum_of(:fuel) }
  end

  describe '#category' do
    it { is_expected.to validate_presence_of(:category) }
    it { expect(create(:vehicle)).to validate_field_enum_of(:category) }
  end

  describe '#kind' do
    it { is_expected.to validate_presence_of(:kind) }
    it { expect(create(:vehicle)).to validate_field_enum_of(:kind) }
  end

  describe '#seats' do
    it { is_expected.to validate_presence_of(:seats) }
    it { expect(create(:vehicle)).to validate_numericality_of(:seats).is_greater_than(0) }
  end

  describe '#plate' do
    it { is_expected.not_to validate_presence_of(:plate) }
  end

  describe '#renavam' do
    it { is_expected.not_to validate_presence_of(:renavam) }
  end

  describe '#licensing' do
    it { is_expected.not_to validate_presence_of(:licensing) }
    it { is_expected.to allow_value('2025/2026').for(:licensing) }
  end

  describe '#notes' do
    it { is_expected.not_to validate_presence_of(:notes) }
    it { is_expected.to validate_length_of(:notes).is_at_most(1024) }
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }
    it { expect(create(:vehicle)).to validate_persistence_of(:subscription) }
    it { expect(create(:vehicle)).to validate_unchange_of(:subscription) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[chassis year plate renavam licensing])
  end
end
