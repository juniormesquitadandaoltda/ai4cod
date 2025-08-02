require 'rails_helper'

module STANDARD
  RSpec.describe AuditsPolicy, type: :policy do
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
    let(:model) { create(:audit, item: subscription) }
    let(:collaborator) { create(:collaborator, subscription:) }
    let(:pundit_user) { { user: collaborator.user, subscription:, params: { id: model.id } } }

    before do
      subscription.update!(due_date: Date.yesterday)
    end

    describe '#index' do
      it 'must be successful' do
        expect(access_subscriber_readonly).not_to receive(:exists?)
        expect(access_subscriber_readonly.send(:index)).to be_truthy
      end

      it 'must be failure' do
        expect(access_user.send(:index)).to be_falsey
        expect(access_admin.send(:index)).to be_falsey
        expect(access_collaborator_readonly.send(:index)).to be_falsey
      end
    end

    describe '#show' do
      it 'must be successful' do
        expect(access_subscriber_readonly).to receive(:exists?).and_call_original
        expect(access_subscriber_readonly.send(:show)).to be_truthy
      end

      it 'must be failure' do
        expect(access_user.send(:show)).to be_falsey
        expect(access_admin.send(:show)).to be_falsey
        expect(access_collaborator_readonly.send(:show)).to be_falsey
      end
    end

    describe '#exists?' do
      it 'must be exists' do
        expect(access_user.send(:exists?)).to be_truthy
      end

      it 'not must be exists' do
        model.destroy!
        expect(access_user.send(:exists?)).to be_falsey
      end

      it 'not must be exists by subscription' do
        model.update_columns(owner_id: create(:user).id)
        expect(access_user.send(:exists?)).to be_falsey
      end
    end
  end
end
