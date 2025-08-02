require 'rails_helper'

module ADMIN
  RSpec.describe AuditsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Audit) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        key: %i[item_id whodunnit_uuid owner_uuid item_type],
        string: %i[whodunnit_email owner_email],
        enum: %i[event]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        event
        item_id
        item_type
        whodunnit_id
        whodunnit_uuid
        whodunnit_email
        owner_id
        owner_uuid
        owner_email
        created_at
        updated_at
      ])
    end
  end
end
