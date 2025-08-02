require 'rails_helper'

RSpec.describe UnchangeValidator, type: :validator do
  subject { described_class.new(User) }

  describe '#validate_each' do
    it 'must be valid' do
      record = create(:subscription)
      attribute = :user
      value = record.user

      subject.validate_each(record, attribute, value)

      expect(record.errors).to be_empty
    end

    it 'must be invalid' do
      record = create(:subscription)
      attribute = :user
      value = nil

      record.user = nil
      subject.validate_each(record, attribute, value)

      expect(record.errors.details[attribute]).to be_include(error: :unchange)
    end
  end
end
