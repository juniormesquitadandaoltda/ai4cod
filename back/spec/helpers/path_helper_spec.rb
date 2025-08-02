require 'rails_helper'

RSpec.describe PathHelper, type: :helper do
  subject { helper }

  describe '#path_helper' do
    let(:params) { ActionController::Parameters.new(id: 1, key: 'value') }

    it 'must be login' do
      controller = 'login/sessions'

      params.merge!(controller:)

      expect(subject.path_helper(params:, controller:, action: :new)).to eq(
        url: '/login/session/new',
        title: t('view.path.new.title'),
        name: :new,
        method: 'get'
      )
    end

    it 'must be admin' do
      allow(subject).to receive(:current_user) { build(:user, :admin) }

      controller = 'admin/sessions'
      params.merge!(controller:)
      expect(subject.path_helper(params:, controller:, action: :show)).to eq(
        url: '/admin/session',
        title: t('view.path.show.title'),
        name: :show,
        method: 'get'
      )

      controller = 'admin/audits'
      params.merge!(controller:)
      expect(subject.path_helper(params:, controller:, action: :index)).to eq(
        url: '/admin/audits?key=value',
        title: t('view.path.index.title'),
        name: :index,
        method: 'get'
      )

      expect(subject.path_helper(params:, controller: 'admin/archives', action: :index)).to eq(
        url: '/admin/archives',
        title: t('view.path.index.title'),
        name: :index,
        method: 'get'
      )
    end

    it 'must be standard' do
      allow(subject).to receive(:current_user) { build(:user, profile: :standard) }

      controller = 'standard/sessions'
      params.merge!(controller:)
      expect(subject.path_helper(params:, controller:, action: :show)).to eq(
        url: '/standard/session',
        title: t('view.path.show.title'),
        name: :show,
        method: 'get'
      )

      controller = 'standard/audits'
      params.merge!(controller:)
      expect(subject.path_helper(params:, controller:, action: :index)).to eq(
        url: '/standard/audits?key=value',
        title: t('view.path.index.title'),
        name: :index,
        method: 'get'
      )

      expect(subject.path_helper(params:, controller: 'standard/archives', action: :index)).to eq(
        url: '/standard/archives',
        title: t('view.path.index.title'),
        name: :index,
        method: 'get'
      )
    end
  end

  it '#index_path_helper' do
    expect(subject.send(:index_path_helper, 0)).to eq(
      method: 'get'
    )
  end

  it '#index_archives_path_helper' do
    expect(subject.send(:index_archives_path_helper, 0)).to eq(
      method: 'get', target: '_blank'
    )
  end

  it '#show_path_helper' do
    expect(subject.send(:show_path_helper, 0)).to eq(
      method: 'get'
    )
  end

  it '#new_path_helper' do
    expect(subject.send(:new_path_helper, 0)).to eq(
      method: 'get'
    )
  end

  it '#new_archives_path_helper' do
    expect(subject.send(:new_archives_path_helper, 0)).to eq(
      method: 'get', target: '_blank'
    )
  end

  it '#edit_path_helper' do
    expect(subject.send(:edit_path_helper, 0)).to eq(
      method: 'get'
    )
  end

  it '#create_path_helper' do
    expect(subject.send(:create_path_helper, 0)).to eq(
      method: 'post'
    )
  end

  it '#update_path_helper' do
    expect(subject.send(:update_path_helper, 0)).to eq(
      method: 'put'
    )
  end

  it '#personificate_path_helper' do
    expect(subject.send(:personificate_path_helper, 0)).to eq(
      method: 'put', message: t('view.path.personificate.message', id: 0)
    )
  end

  it '#destroy_path_helper' do
    expect(subject.send(:destroy_path_helper, 0)).to eq(
      method: 'delete', message: t('view.path.destroy.message', id: 0)
    )
  end

  it '#export_path_helper' do
    expect(subject.send(:export_path_helper, 0)).to eq(
      method: 'patch', message: t('view.path.export.message')
    )
  end

  it '#preview_path_helper' do
    expect(subject.send(:preview_path_helper, 0)).to eq(
      method: 'get', target: '_blank'
    )
  end
end
