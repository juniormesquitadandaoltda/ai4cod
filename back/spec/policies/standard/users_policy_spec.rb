require 'rails_helper'

module STANDARD
  RSpec.describe UsersPolicy, type: :policy do
    let!(:access_subscriber) do
      instance = described_class.new(pundit_user)
      allow(instance).to receive(:subscriber?).and_return(true)
      instance
    end
    let!(:access_subscriber_readonly) do
      instance = described_class.new(pundit_user)
      allow(instance).to receive(:subscriber_readonly?).and_return(true)
      instance
    end
    let!(:access_collaborator) do
      instance = described_class.new(pundit_user)
      allow(instance).to receive(:collaborator?).and_return(true)
      instance
    end
    let!(:access_collaborator_readonly) do
      instance = described_class.new(pundit_user)
      allow(instance).to receive(:collaborator_readonly?).and_return(true)
      instance
    end
    let!(:access_user) { described_class.new(pundit_user.merge(user:), nil) }
    let!(:access_admin) { described_class.new(pundit_user.merge(user: admin), nil) }

    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user, profile: :standard) }
    let(:subscription) { create(:subscription) }
    let(:model) { create(:user) }
    let(:collaborator) { create(:collaborator, subscription:) }
    let(:pundit_user) { { user: collaborator.user, subscription:, params: { id: model.id } } }

    before do
      subscription.update!(due_date: Date.yesterday)
    end

    describe '#index' do
      it 'must be successful' do
        expect(access_subscriber_readonly.send(:index)).to be_truthy
      end

      it 'must be failure' do
        expect(access_user.send(:index)).to be_falsey
        expect(access_admin.send(:index)).to be_falsey
        expect(access_collaborator_readonly.send(:index)).to be_falsey
      end
    end
  end
end
