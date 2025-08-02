require 'rails_helper'

module STANDARD
  RSpec.describe ArchivesFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Archive) }
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        key: %i[record_id],
        string: %i[filename record_type]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        filename
        byte_size
        record_id
        record_type
        created_at
        updated_at
      ])
    end
  end
end
