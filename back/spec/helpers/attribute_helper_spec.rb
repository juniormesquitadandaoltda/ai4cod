require 'rails_helper'

RSpec.describe AttributeHelper, type: :helper do
  subject { helper }

  let(:model) { User }
  let(:name) { :name }
  let(:subscription) { create(:subscription) }

  describe '#attribute_helper' do
    it 'must be enum' do
      expect(subject.attribute_helper(model:, name: :profile, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'profile',
        type: 'enum',
        title: User.human_attribute_name(:profile),
        listable: true,
        searchable: true,
        inputable: true
      )
    end

    it 'must be field_enum' do
      expect(subject.attribute_helper(model: Vehicle, name: :brand, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'brand',
        type: 'field_enum',
        title: Vehicle.human_attribute_name(:brand),
        listable: true,
        searchable: true,
        inputable: true
      )
    end

    it 'must be reference' do
      allow(subject).to receive(:current_user) { build(:user, profile: :standard) }

      expect(subject.attribute_helper(model: Subscription, name: :user, listable: true, searchable: true, inputable: true, subscription:)).to eq(
        name: 'user',
        type: 'reference',
        title: Subscription.human_attribute_name(:user),
        listable: true,
        searchable: true,
        inputable: true,
        paths: [
          subject.path_helper(params:, controller: 'users', action: :index)
        ],
        reference: { name: 'email', type: 'string', title: User.human_attribute_name(:email), key: :uuid }
      )

      expect(subject.attribute_helper(model: Task, name: :vehicle, listable: true, searchable: true, inputable: true, subscription:)).to eq(
        name: 'vehicle',
        type: 'reference',
        title: Task.human_attribute_name(:vehicle),
        listable: true,
        searchable: true,
        inputable: true,
        paths: [
          subject.path_helper(params:, controller: 'vehicles', action: :index)
        ],
        reference: { name: 'plate', type: 'string', title: Vehicle.human_attribute_name(:plate), key: :plate }
      )

      expect(subject.attribute_helper(model: Archive, name: :record, listable: true, searchable: true, inputable: true, subscription:)).to eq(
        name: 'record',
        type: 'reference',
        title: Archive.human_attribute_name(:record),
        listable: true,
        searchable: true,
        inputable: true,
        paths: [
          subject.path_helper(params:, controller: 'archives', action: :index)
        ],
        reference: { name: 'type', type: 'string', title: Archive.human_attribute_name(:type), key: :id }
      )
    end

    it 'must be secret' do
      expect(subject.attribute_helper(model: User, name: :password, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'password',
        type: 'secret',
        title: User.human_attribute_name(:password),
        listable: true,
        searchable: true,
        inputable: true
      )
    end

    it 'must be boolean' do
      expect(subject.attribute_helper(model: User, name: :remember_me, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'remember_me',
        type: 'boolean',
        title: User.human_attribute_name(:remember_me),
        listable: true,
        searchable: true,
        inputable: true
      )
    end

    it 'must be string' do
      expect(subject.attribute_helper(model:, name:, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'name',
        type: 'string',
        title: model.human_attribute_name(name),
        listable: true,
        searchable: true,
        inputable: true
      )

      expect(subject.attribute_helper(model:, name: :failure_reason, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'failure_reason',
        type: 'string',
        title: model.human_attribute_name(:failure_reason),
        listable: true,
        searchable: true,
        inputable: true
      )

      expect(subject.attribute_helper(model:, name: :filename, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'filename',
        type: 'string',
        title: model.human_attribute_name(:filename),
        listable: true,
        searchable: true,
        inputable: true
      )
    end

    it 'must be byte' do
      expect(subject.attribute_helper(model: Archive, name: :byte_size, listable: true, searchable: true, inputable: true, subscription:)).to include_json(
        name: 'byte_size',
        type: 'byte',
        title: Archive.human_attribute_name(:byte_size),
        listable: true,
        searchable: false,
        inputable: false
      )
    end
  end

  it '#uuid_attribute_helper' do
    expect(subject.send(:uuid_attribute_helper, model:, name: :uuid, subscription:)).to eq(
      title: ApplicationRecord.human_attribute_name(:uuid)
    )
  end

  describe '#string_attribute_helper' do
    it 'must be mask' do
      expect(subject.send(:string_attribute_helper, model: Vehicle, name: :year, subscription:)).to eq(
        mask: '9999/9999'
      )

      expect(subject.send(:string_attribute_helper, model: Vehicle, name: :licensing, subscription:)).to eq(
        mask: '9999/9999'
      )
    end

    it 'must be standard' do
      expect(subject.send(:string_attribute_helper, model:, name:, subscription:)).to be_empty
    end
  end

  it '#text_attribute_helper' do
    expect(subject.send(:text_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#enum_attribute_helper' do
    expect(subject.send(:enum_attribute_helper, model:, name: :profile, subscription:)).to eq(
      enum: User.profiles_i18n.map { |key, value| { value: key, title: value } }
    )
  end

  it '#field_enum_attribute_helper' do
    expect(subject.send(:field_enum_attribute_helper, model: Vehicle, name: :brand, subscription:)).to eq(
      enum: Vehicle.new(subscription:).field_brands.map { |value| { value:, title: value } }
    )
  end

  it '#boolean_attribute_helper' do
    expect(subject.send(:boolean_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  describe '#bigint_attribute_helper' do
    it 'must be empty' do
      expect(subject.send(:bigint_attribute_helper, model:, name: :count, subscription:)).to be_empty
    end

    it 'must be id' do
      expect(subject.send(:bigint_attribute_helper, model:, name: :id, subscription:)).to eq(
        title: ApplicationRecord.human_attribute_name(:id)
      )
    end
  end

  describe '#timestamp_attribute_helper' do
    it 'must be empty' do
      expect(subject.send(:timestamp_attribute_helper, model:, name: :deleted_at, subscription:)).to be_empty
    end

    it 'must be created_at' do
      expect(subject.send(:timestamp_attribute_helper, model:, name: :created_at, subscription:)).to eq(
        title: ApplicationRecord.human_attribute_name(:created_at)
      )
    end

    it 'must be updated_at' do
      expect(subject.send(:timestamp_attribute_helper, model:, name: :updated_at, subscription:)).to eq(
        title: ApplicationRecord.human_attribute_name(:updated_at)
      )
    end
  end

  describe '#reference_attribute_helper' do
    before do
      allow(subject).to receive(:current_user) { build(:user, profile: :standard) }
    end

    it 'must be whodunnit' do
      expect(subject.send(:reference_attribute_helper, model:, name: :whodunnit, subscription:)).to eq(
        paths: [
          subject.path_helper(params:, controller: 'users', action: :index)
        ],
        reference: { name: 'email', type: 'string', title: User.human_attribute_name(:email), key: :uuid }
      )
    end

    it 'must be owner' do
      expect(subject.send(:reference_attribute_helper, model:, name: :owner, subscription:)).to eq(
        paths: [
          subject.path_helper(params:, controller: 'users', action: :index)
        ],
        reference: { name: 'email', type: 'string', title: User.human_attribute_name(:email), key: :uuid }
      )
    end

    it 'must be user' do
      expect(subject.send(:reference_attribute_helper, model:, name: :user, subscription:)).to eq(
        paths: [
          subject.path_helper(params:, controller: 'users', action: :index)
        ],
        reference: { name: 'email', type: 'string', title: User.human_attribute_name(:email), key: :uuid }
      )
    end
  end

  it '#json_attribute_helper' do
    expect(subject.send(:json_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#array_attribute_helper' do
    expect(subject.send(:array_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#integer_attribute_helper' do
    expect(subject.send(:integer_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#decimal_attribute_helper' do
    expect(subject.send(:decimal_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#secret_attribute_helper' do
    expect(subject.send(:secret_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#attachment_attribute_helper' do
    expect(subject.send(:attachment_attribute_helper, model:, name:, subscription:)).to be_empty
  end

  it '#byte_attribute_helper' do
    expect(subject.send(:byte_attribute_helper, model:, name: :byte_size, subscription:)).to eq(
      searchable: false,
      inputable: false
    )
  end
end
