require 'rails_helper'

module STANDARD
  RSpec.describe ProprietorsFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Proprietor) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        string: %i[name email]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        email
        created_at
        updated_at
      ])
    end
  end
end
