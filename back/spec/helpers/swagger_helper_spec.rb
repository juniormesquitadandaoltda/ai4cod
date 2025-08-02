require 'rails_helper'

RSpec.describe SwaggerHelper, type: :helper do
  subject { helper }

  describe '#swagger_helper' do
    it 'must be login' do
      expect(subject.swagger_helper(:login)).to be_include(
        controller: '/login/sessions',
        actions: %i[create destroy new update]
      )
    end

    it 'must be admin' do
      expect(subject.swagger_helper(:admin)).to be_include(
        controller: '/admin/sessions',
        actions: %i[show]
      )
    end

    it 'must be standard' do
      expect(subject.swagger_helper(:standard)).to be_include(
        controller: '/standard/sessions',
        actions: %i[show]
      )
    end
  end
end
