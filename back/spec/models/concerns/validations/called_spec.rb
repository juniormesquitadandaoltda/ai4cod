require 'rails_helper'

RSpec.describe Called, type: :model do
  describe '#subject' do
    it { is_expected.to validate_presence_of(:subject) }

    it { expect(create(:called)).to validate_uniqueness_of(:subject).scoped_to(:subscription_id).case_insensitive }
  end

  describe '#message' do
    it { is_expected.to validate_presence_of(:message) }

    it { expect(create(:called)).to validate_change_of(:message).with(:answer_blank?) }
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }

    it { expect(create(:called)).to validate_persistence_of(:subscription) }

    it { expect(create(:called)).to validate_unchange_of(:subscription) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[subject message answer])
  end

  it '#answer_blank?' do
    expect(subject.send(:answer_blank?)).to be_truthy

    subject.answer = 'value'

    expect(subject.send(:answer_blank?)).to be_falsey
  end
end
