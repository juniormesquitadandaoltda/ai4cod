require 'rails_helper'

module STANDARD
  RSpec.describe FieldsFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Field) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        enum: %i[resource name]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        resource
        created_at
        updated_at
      ])
    end
  end
end
