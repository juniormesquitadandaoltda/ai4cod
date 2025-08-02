require 'rails_helper'

module ADMIN
  RSpec.describe ApplicationPolicy, type: :policy do
    subject! { described_class.new(pundit_user, nil) }

    let(:admin) { create(:user, :admin) }
    let(:pundit_user) { { user: admin, params: { id: 0 } } }

    describe '.attr_reader' do
      it { expect(subject.user).to eq(admin) }
      it { expect(subject.params).to eq(id: 0) }
    end

    describe '#admin?' do
      it 'must be admin' do
        expect(subject.send(:admin?)).to be_truthy
      end

      it 'not must be admin' do
        admin.profile_standard!
        expect(subject.send(:admin?)).to be_falsey
      end
    end
  end
end
