require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  describe '#user' do
    it { is_expected.to validate_presence_of(:user) }

    it { expect(create(:collaborator)).to validate_persistence_of(:user) }

    it { expect(create(:collaborator)).to validate_unchange_of(:user) }

    it { expect(create(:collaborator)).to validate_comparison_of(:user).other_than(:subscription_user) }

    it { expect(create(:collaborator)).to validate_uniqueness_of(:user).scoped_to(:subscription_id) }

    it '#validate_user_profile' do
      subject.user = build(:user, :admin)

      subject.valid?

      expect(subject.errors.details[:user]).to be_include(error: :invalid_profile)
    end
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }

    it { expect(create(:collaborator)).to validate_persistence_of(:subscription) }

    it { expect(create(:collaborator)).to validate_unchange_of(:subscription) }
  end

  describe '#actived' do
    it { is_expected.not_to validate_presence_of(:actived) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to be_empty
  end
end
