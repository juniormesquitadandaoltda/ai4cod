require 'rails_helper'

module STANDARD
  RSpec.describe CollaboratorsFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Collaborator) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        boolean: %i[actived],
        string: %i[user_email],
        key: %i[user_uuid]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        actived
        user_id
        user_uuid
        user_email
        created_at
        updated_at
      ])
    end
  end
end
