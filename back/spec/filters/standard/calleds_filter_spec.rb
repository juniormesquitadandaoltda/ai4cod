require 'rails_helper'

module STANDARD
  RSpec.describe CalledsFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { nil }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Called) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        string: %i[subject]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        subject
        created_at
        updated_at
      ])
    end
  end
end
