require 'rails_helper'

module STANDARD
  RSpec.describe TasksFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Task) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        string: %i[name vehicle_plate],
        field_enum: %i[stage next_stage],
        date: %i[scheduling_at],
        boolean: %i[shared],
        key: %i[vehicle_id]
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
        created_at
        updated_at
      ])
    end

    describe '#search' do
      let(:subscription_2) { create(:subscription) }

      it 'must be current_subscription' do
        subject.assign_attributes(
          current_user:,
          current_subscription:,
          sort: 'id',
          order: 'asc',
          page: 1,
          limit: 100
        )

        expect(subject.search).to be_truthy
        expect(subject.results).to be_empty

        task_1 = create(:task, subscription: current_subscription)
        task_2 = create(:task, subscription: subscription_2)

        expect(subject.search).to be_truthy
        expect(subject.results).to eq([task_1])
      end

      it 'must be proprietor' do
        subject.assign_attributes(
          current_user:,
          sort: 'id',
          order: 'asc',
          page: 1,
          limit: 100
        )

        expect(subject.search).to be_truthy
        expect(subject.results).to be_empty

        proprietor = create(:proprietor, email: current_user.email)
        task_1 = create(:task, proprietor:)
        task_2 = create(:task, name: '2', proprietor: create(:proprietor, name: '2'))

        expect(subject.search).to be_truthy
        expect(subject.results).to eq([task_1])
      end

      it 'must be facilitator' do
        subject.assign_attributes(
          current_user:,
          sort: 'id',
          order: 'asc',
          page: 1,
          limit: 100
        )

        expect(subject.search).to be_truthy
        expect(subject.results).to be_empty

        facilitator = create(:facilitator, email: current_user.email)
        task_1 = create(:task, facilitator:)
        task_2 = create(:task, name: '2', facilitator: create(:facilitator, name: '2'))

        expect(subject.search).to be_truthy
        expect(subject.results).to eq([task_1])
      end
    end
  end
end
