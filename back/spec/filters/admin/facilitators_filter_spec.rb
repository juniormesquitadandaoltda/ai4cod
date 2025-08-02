require 'rails_helper'

module ADMIN
  RSpec.describe FacilitatorsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Facilitator) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[name email subscription_name],
        key: %i[subscription_id]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        email
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
