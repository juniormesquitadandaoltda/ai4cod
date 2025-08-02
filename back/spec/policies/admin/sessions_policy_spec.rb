require 'rails_helper'

module ADMIN
  RSpec.describe SessionsPolicy, type: :policy do
    let!(:access_user) { described_class.new(pundit_user.merge(user:), nil) }
    let!(:access_admin) { described_class.new(pundit_user.merge(user: admin), nil) }

    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user, profile: :standard) }

    let(:model) { {} }
    let(:pundit_user) { { params: model } }

    describe '#show' do
      it 'must be successful' do
        expect(access_admin.send(:show)).to be_truthy
      end

      it 'must be failure' do
        expect(access_user.send(:show)).to be_falsey
      end
    end
  end
end
