require 'rails_helper'

module ADMIN
  RSpec.describe NotificationsFilter, type: :filter do
    let(:current_user) { create(:user) }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Notification) }
    end

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        string: %i[notificator_name],
        key: %i[notificator_id]
      )
    end

    it '#select' do
      expect(subject.send(:select)).to eq(%i[
        id
        notificator_id
        notificator_name
        created_at
        updated_at
      ])
    end
  end
end
