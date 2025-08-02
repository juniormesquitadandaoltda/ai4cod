require 'rails_helper'

RSpec.describe PersistenceValidator, type: :validator do
  subject { described_class.new(User) }

  describe '#validate_each' do
    it 'must be valid' do
      record = build(:subscription)
      attribute = :user
      value = create(:user)

      subject.validate_each(record, attribute, value)

      expect(record.errors).to be_empty
    end

    it 'must be invalid' do
      record = build(:subscription)
      attribute = :user
      value = build(:user)

      subject.validate_each(record, attribute, value)

      expect(record.errors.details[attribute]).to be_include(error: :persistence)
    end
  end
end
