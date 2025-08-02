require 'rails_helper'

RSpec.describe ApplicationService, type: :service do
  it { is_expected.to be_is_a(::ActiveModel::Model) }

  describe '#result' do
    it { is_expected.to be_respond_to(:result) }
    it { is_expected.not_to be_respond_to(:result=) }
  end

  describe '#call' do
    it 'must be valid' do
      expect(subject).to receive(:run).and_return(true)

      expect(subject.call).to be_truthy
      expect(subject.errors).to be_empty
    end

    it 'must be invalid' do
      subject.errors.add(:base, 'message')

      expect(subject).to receive(:valid?).and_return(false)

      expect(subject).not_to receive(:run)

      expect(subject.call).to be_falsey
      expect(subject.errors.details[:base]).to be_include(error: 'message')
    end

    it 'must be invalid by run' do
      class << subject
        def run
          errors.add(:base, 'message')
        end
      end

      expect(subject.call).to be_falsey
      expect(subject.errors.details[:base]).to be_include(error: 'message')
    end
  end
end
