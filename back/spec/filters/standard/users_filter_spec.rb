require 'rails_helper'

module STANDARD
  RSpec.describe UsersFilter, type: :filter do
    let(:current_user) { create(:user) }
    let(:current_subscription) { create(:subscription) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::User) }
    end

    it '#sortables' do
      expect(subject.sortables).to eq(%w[uuid id created_at updated_at email])
    end

    it '.search_attributes' do
      expect(subject).to standard_search_attributes(
        key: %i[uuid]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        uuid
        email
      ])
    end
  end
end
