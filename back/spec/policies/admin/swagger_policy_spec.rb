require 'rails_helper'

module ADMIN
  RSpec.describe SwaggerPolicy, type: :policy do
    let!(:access_user) { described_class.new(pundit_user.merge(user:), nil) }
    let!(:access_admin) { described_class.new(pundit_user.merge(user: admin), nil) }

    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user, profile: :standard) }

    let(:model) { { version: 'v1', file: 'admin' } }
    let(:pundit_user) { { params: model } }

    describe '#show' do
      it 'must be successful' do
        expect(access_admin).to receive(:exists?).and_call_original
        expect(access_admin.send(:show)).to be_truthy
      end

      it 'must be failure' do
        expect(access_user.send(:show)).to be_falsey
      end
    end

    describe '#exists?' do
      it 'must be exists' do
        expect(access_user.send(:exists?)).to be_truthy
      end

      it 'not must be exists' do
        model[:version] = 'v0'
        expect(access_admin.send(:exists?)).to be_falsey
      end
    end
  end
end
