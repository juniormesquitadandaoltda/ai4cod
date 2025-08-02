require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  subject { helper }

  describe '#authorized_application_helper?' do
    before do
      class << subject
        def policy(_path)
          ADMIN::UsersPolicy.new({ user: User.new(profile: :admin), params: {} }, {})
        end
      end
    end

    it 'must be call action' do
      expect(subject).to be_authorized_application_helper(:'admin/users', :index, { key: 'value' })
    end

    it 'not must be call action' do
      expect(subject).not_to be_authorized_application_helper(:'admin/users', :destroy, { key: 'value' })
    end
  end
end
