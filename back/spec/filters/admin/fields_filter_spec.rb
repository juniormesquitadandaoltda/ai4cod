require 'rails_helper'

module ADMIN
  RSpec.describe FieldsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Field) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[subscription_name],
        enum: %i[resource name],
        key: %i[subscription_id]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        resource
        subscription_id
        subscription_name
        created_at
        updated_at
      ])
    end
  end
end
