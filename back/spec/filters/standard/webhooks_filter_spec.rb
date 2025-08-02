require 'rails_helper'

module STANDARD
  RSpec.describe WebhooksFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Webhook) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        string: %i[url],
        enum: %i[resource event],
        boolean: %i[actived]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        url
        resource
        event
        actived
        created_at
        updated_at
      ])
    end
  end
end
