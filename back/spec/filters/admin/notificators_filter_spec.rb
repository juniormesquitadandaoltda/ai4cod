require 'rails_helper'

module ADMIN
  RSpec.describe NotificatorsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Notificator) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[name],
        boolean: %i[actived]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        name
        actived
        notifications_count
        created_at
        updated_at
      ])
    end
  end
end
