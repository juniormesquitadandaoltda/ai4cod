require 'rails_helper'

module STANDARD
  RSpec.describe VehiclesFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Vehicle) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        string: %i[chassis year plate renavam licensing],
        bigint: %i[seats]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        chassis
        year
        seats
        plate
        renavam
        licensing
        created_at
        updated_at
      ])
    end
  end
end
