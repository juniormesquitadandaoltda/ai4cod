require 'rails_helper'

RSpec.describe Facilitator, type: :model do
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#email' do
    it { is_expected.to validate_presence_of(:email) }
    it { expect(create(:facilitator)).to validate_uniqueness_of(:email).scoped_to(:subscription_id).case_insensitive }
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }
    it { expect(create(:facilitator)).to validate_persistence_of(:subscription) }
    it { expect(create(:facilitator)).to validate_unchange_of(:subscription) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[name email])
  end
end
