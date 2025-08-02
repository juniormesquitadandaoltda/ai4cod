require 'rails_helper'

module STANDARD
  RSpec.describe ApplicationPolicy, type: :policy do
    subject! { described_class.new(pundit_user, nil) }

    let(:user) { create(:user, profile: :standard) }
    let(:subscription) { create(:subscription, user:) }
    let(:client) { user }
    let(:pundit_user) { { user:, subscription:, params: { id: 0 }, client: } }

    describe '.attr_reader' do
      it { expect(subject.user).to eq(user) }
      it { expect(subject.subscription).to eq(subscription) }
      it { expect(subject.client).to eq(client) }
      it { expect(subject.params).to eq(id: 0) }
    end

    describe '#standard?' do
      it 'must be user' do
        expect(subject.send(:standard?)).to be_truthy
      end

      it 'not must be user' do
        user.profile_admin!
        expect(subject.send(:standard?)).to be_falsey
      end
    end

    describe '#subscriber?' do
      it 'must be subscriber' do
        expect(subject.send(:subscriber?)).to be_truthy
      end

      it 'not must be subscriber by profile' do
        user.profile_admin!
        expect(subject.send(:subscriber?)).to be_falsey
      end

      it 'not must be subscriber by actived' do
        subscription.update_columns(actived: false)
        expect(subject.send(:subscriber?)).to be_falsey
      end

      it 'not must be subscriber by user' do
        subscription.update_columns(user_id: create(:user).id)
        expect(subject.send(:subscriber?)).to be_falsey
      end

      it 'not must be subscriber expired' do
        subscription.update_columns(due_date: Date.yesterday)
        expect(subject.send(:subscriber?)).to be_falsey
      end
    end

    describe '#subscriber_readonly?' do
      it 'must be subscriber_readonly' do
        expect(subject.send(:subscriber_readonly?)).to be_truthy
      end

      it 'not must be subscriber_readonly by profile' do
        user.profile_admin!
        expect(subject.send(:subscriber_readonly?)).to be_falsey
      end

      it 'not must be subscriber_readonly by actived' do
        subscription.update_columns(actived: false)
        expect(subject.send(:subscriber_readonly?)).to be_falsey
      end

      it 'must be subscriber_readonly expired' do
        subscription.update_columns(due_date: Date.yesterday)
        expect(subject.send(:subscriber_readonly?)).to be_truthy
      end

      it 'not must be subscriber_readonly by user' do
        subscription.update_columns(user_id: create(:user).id)
        expect(subject.send(:subscriber_readonly?)).to be_falsey
      end
    end

    describe '#collaborator?' do
      let(:subscription) { create(:subscription, user: create(:user)) }
      let!(:collaborator) { create(:collaborator, actived: true, user:, subscription:) }

      it 'must be subscriber' do
        expect(subject).to receive(:subscriber?).and_return(true)
        expect(subject.send(:collaborator?)).to be_truthy
      end

      it 'must be collaborator' do
        expect(subject).to receive(:subscriber?).and_return(false)
        expect(subject.send(:collaborator?)).to be_truthy
      end

      it 'not must be collaborator by profile' do
        expect(subject).to receive(:subscriber?).and_return(false)
        user.profile_admin!
        expect(subject.send(:collaborator?)).to be_falsey
      end

      it 'not must be collaborator by actived' do
        expect(subject).to receive(:subscriber?).and_return(false)
        collaborator.update_columns(actived: false)
        expect(subject.send(:collaborator?)).to be_falsey
      end

      it 'not must be collaborator by expired' do
        expect(subject).to receive(:subscriber?).and_return(false)
        subscription.update_columns(due_date: Date.yesterday)
        expect(subject.send(:collaborator?)).to be_falsey
      end

      it 'not must be collaborator by user' do
        expect(subject).to receive(:subscriber?).and_return(false)
        collaborator.update_columns(user_id: create(:user).id)
        expect(subject.send(:collaborator?)).to be_falsey
      end
    end

    describe '#collaborator_readonly?' do
      let(:subscription) { create(:subscription, user: create(:user)) }
      let!(:collaborator) { create(:collaborator, actived: true, user:, subscription:) }

      it 'must be collaborator' do
        expect(subject).to receive(:collaborator?).and_return(true)
        expect(subject.send(:collaborator_readonly?)).to be_truthy
      end

      it 'not must be collaborator by profile' do
        expect(subject).to receive(:collaborator?).and_return(false)
        user.profile_admin!
        expect(subject.send(:collaborator_readonly?)).to be_falsey
      end

      it 'not must be collaborator by actived' do
        expect(subject).to receive(:collaborator?).and_return(false)
        collaborator.update_columns(actived: false)
        expect(subject.send(:collaborator_readonly?)).to be_falsey
      end

      it 'not must be collaborator by expired' do
        expect(subject).to receive(:collaborator?).and_return(false)
        subscription.update_columns(due_date: Date.yesterday)
        expect(subject.send(:collaborator_readonly?)).to be_truthy
      end

      it 'not must be collaborator by user' do
        expect(subject).to receive(:collaborator?).and_return(false)
        collaborator.update_columns(user_id: create(:user).id)
        expect(subject.send(:collaborator_readonly?)).to be_falsey
      end
    end

    describe '#client_readonly?' do
      it 'must be collaborator_readonly' do
        expect(subject.send(:client_readonly?)).to be_truthy
      end

      it 'must be proprietor' do
        expect(subject).to receive(:collaborator_readonly?).and_return(false).at_least(:once)

        proprietor = create(:proprietor, email: user.email)
        expect(subject.send(:client_readonly?)).to be_falsey

        create(:task, proprietor:)
        expect(subject.send(:client_readonly?)).to be_truthy
      end

      it 'must be facilitator' do
        expect(subject).to receive(:collaborator_readonly?).and_return(false).at_least(:once)

        facilitator = create(:facilitator, email: user.email)
        expect(subject.send(:client_readonly?)).to be_falsey

        create(:task, facilitator:)
        expect(subject.send(:client_readonly?)).to be_truthy
      end
    end
  end
end
