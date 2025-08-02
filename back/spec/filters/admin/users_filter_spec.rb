require 'rails_helper'

module ADMIN
  RSpec.describe UsersFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::User) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        key: %i[uuid],
        string: %i[email],
        enum: %i[status profile]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        uuid
        email
        status
        profile
        created_at
        updated_at
      ])
    end
  end
end
