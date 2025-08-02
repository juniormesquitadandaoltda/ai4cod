require 'rails_helper'

module ADMIN
  RSpec.describe ArchivesFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Archive) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        key: %i[record_id subscription_id],
        string: %i[filename subscription_name record_type]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        filename
        record_id
        record_type
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
