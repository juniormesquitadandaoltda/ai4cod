require 'rails_helper'

module ADMIN
  RSpec.describe TasksFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Task) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[name subscription_name vehicle_plate],
        field_enum: %i[stage next_stage],
        date: %i[scheduling_at],
        boolean: %i[shared],
        key: %i[subscription_id vehicle_id]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        stage
        next_stage
        scheduling_at
        shared
        vehicle_id
        vehicle_plate
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
