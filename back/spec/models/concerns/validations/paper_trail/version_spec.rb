require 'rails_helper'

module PaperTrail
  RSpec.describe Version, type: :model do
    describe '.before_validation' do
      describe 'on create' do
        after { subject.save }

        it { is_expected.to receive(:config_whodunnit!) }
        it { is_expected.to receive(:config_owner!) }
      end

      describe 'on update' do
        subject { create(:audit) }

        after { subject.save }

        it { is_expected.not_to receive(:config_whodunnit!) }
        it { is_expected.not_to receive(:config_owner!) }
      end
    end

    describe '.after_commit' do
      describe 'on create' do
        subject { build(:audit) }

        after { subject.save! }

        it { is_expected.to receive(:after_create_self!) }
      end

      describe 'on update' do
        subject { create(:audit) }

        after { subject.save! }

        it { is_expected.not_to receive(:after_create_self!) }
      end
    end

    describe '#event' do
      it { is_expected.to validate_presence_of(:event) }

      it { expect(create(:audit)).to validate_unchange_of(:event) }
    end

    describe '#whodunnit' do
      it { is_expected.to validate_presence_of(:whodunnit) }

      it { expect(create(:audit)).to validate_persistence_of(:whodunnit) }

      it { expect(create(:audit)).to validate_unchange_of(:whodunnit) }
    end

    describe '#owner' do
      it { is_expected.to validate_presence_of(:owner) }

      it { expect(create(:audit)).to validate_persistence_of(:owner) }

      it { expect(create(:audit)).to validate_unchange_of(:owner) }
    end

    describe '#object_changes' do
      it { is_expected.to validate_presence_of(:object_changes) }
    end

    describe '#config_whodunnit!' do
      let(:user) { build(:user) }
      let(:admin) { build(:user, :admin) }
      let(:subscription) { build(:subscription, user:) }

      it 'must be user' do
        subject.item = user
        subject.send(:config_whodunnit!)
        expect(subject.whodunnit).to eq(user)

        subject.whodunnit = nil
        subject.item = subscription
        subject.send(:config_whodunnit!)
        expect(subject.whodunnit).to eq(user)

        subject.whodunnit = nil
        subject.item = build(:webhook, subscription:)
        subject.send(:config_whodunnit!)
        expect(subject.whodunnit).to eq(user)
      end

      it 'must be admin' do
        subject.whodunnit = admin
        subject.item = user

        subject.send(:config_whodunnit!)

        expect(subject.whodunnit).to eq(admin)
      end
    end

    describe '#config_owner!' do
      let(:user) { build(:user) }
      let(:admin) { build(:user, :admin) }

      it 'from user' do
        subject.item = user

        subject.send(:config_owner!)

        expect(subject.owner).to eq(user)
      end

      it 'from subscription' do
        subject.item = build(:subscription)

        subject.send(:config_owner!)

        expect(subject.owner).to eq(subject.item.user)
      end

      it 'from another' do
        subject.item = build(:collaborator)

        subject.send(:config_owner!)

        expect(subject.owner).to eq(subject.item.subscription.user)
      end

      it 'must be admin' do
        subject.whodunnit = admin
        subject.item = user

        subject.send(:config_owner!)

        expect(subject.owner).to eq(admin)
      end
    end

    it '#after_create_self!' do
      subject.id = 1
      subject.item = ::Collaborator.new
      PaperTrail.request.whodunnit = build(:user)

      expect(::STANDARD::AuditsJob).to receive(:perform_later).with(audit: subject, whodunnit: PaperTrail.request.whodunnit)

      subject.send(:after_create_self!)
    end
  end
end
