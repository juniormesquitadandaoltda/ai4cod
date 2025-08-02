require 'rails_helper'

module ADMIN
  RSpec.describe VehiclesFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Vehicle) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[chassis year plate renavam licensing subscription_name],
        bigint: %i[seats],
        key: %i[subscription_id]
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
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
