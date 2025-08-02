require 'rails_helper'

module ADMIN
  RSpec.describe SubscriptionsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Subscription) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[name user_email],
        boolean: %i[actived],
        key: %i[user_uuid],
        date: %i[due_date]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        actived
        due_date
        user_id
        user_uuid
        user_email
        created_at
        updated_at
      ])
    end
  end
end
