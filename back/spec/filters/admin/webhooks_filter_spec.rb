require 'rails_helper'

module ADMIN
  RSpec.describe WebhooksFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Webhook) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[url subscription_name],
        enum: %i[resource event],
        boolean: %i[actived],
        key: %i[subscription_id]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        url
        resource
        event
        actived
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
