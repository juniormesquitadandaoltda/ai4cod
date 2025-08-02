require 'rails_helper'

module STANDARD
  RSpec.describe SessionsPolicy, type: :policy do
    let!(:access_collaborator) { described_class.new(pundit_user.merge(user: collaborator.user), nil) }

    let!(:access_subscriber) { described_class.new(pundit_user.merge(user: collaborator.subscription.user), nil) }

    let!(:access_user) { described_class.new(pundit_user.merge(user:), nil) }

    let!(:access_admin) { described_class.new(pundit_user.merge(user: admin), nil) }

    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user, profile: :standard) }
    let(:subscription) { create(:subscription) }
    let(:collaborator) { create(:collaborator) }
    let(:pundit_user) { { subscription: collaborator.subscription, params: { id: 0 } } }

    before do
      subscription.update!(due_date: Date.yesterday)
    end

    describe '#show' do
      it 'must be show' do
        expect(access_user.send(:show)).to be_truthy
      end

      it 'not must be show' do
        expect(access_admin.send(:show)).to be_falsey
      end
    end
  end
end
