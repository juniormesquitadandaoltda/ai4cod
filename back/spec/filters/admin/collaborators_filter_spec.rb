require 'rails_helper'

module ADMIN
  RSpec.describe CollaboratorsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Collaborator) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        boolean: %i[actived],
        string: %i[user_email subscription_name],
        key: %i[user_uuid subscription_id]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        actived
        user_id
        user_uuid
        user_email
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
