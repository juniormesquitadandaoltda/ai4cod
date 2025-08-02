require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  describe '.before_validation' do
    describe 'on create' do
      subject { build(:subscription) }

      after { subject.save }

      it { is_expected.to receive(:before_validation_subscription_current_records_count!) }
      it { is_expected.to receive(:before_validation_subscription_due_date!) }
    end

    describe 'on update' do
      subject { create(:subscription) }

      after { subject.save }

      it { is_expected.not_to receive(:before_validation_subscription_current_records_count!) }
      it { is_expected.to receive(:before_validation_subscription_due_date!) }
    end
  end

  describe '.after_save_commit' do
    describe 'on create' do
      subject { build(:subscription) }

      after { subject.save! }

      it { is_expected.to receive(:after_create_subscription_current_records_count!) }
      it { is_expected.to receive(:after_save_configure_searchable!) }
      it { is_expected.not_to receive(:after_destroy_subscription_current_records_count!) }
    end

    describe 'on update' do
      subject { create(:subscription) }

      after { subject.save! }

      it { is_expected.not_to receive(:after_create_subscription_current_records_count!) }
      it { is_expected.to receive(:after_save_configure_searchable!) }
      it { is_expected.not_to receive(:after_destroy_subscription_current_records_count!) }
    end
  end

  describe '.after_destroy_commit' do
    describe 'on destroy' do
      subject { create(:subscription) }

      after do
        subject.fields.destroy_all
        subject.destroy!
      end

      it { is_expected.not_to receive(:after_create_subscription_current_records_count!) }
      it { is_expected.not_to receive(:after_save_configure_searchable!) }
      it { is_expected.to receive(:after_destroy_subscription_current_records_count!) }
    end
  end

  describe '.custom_create' do
    context 'with uuid' do
      let(:user) { create(:user).reload }

      it 'must find' do
        subscription = Subscription.custom_create(user: { uuid: user.uuid })

        expect(subscription.user).to be_persisted
        expect(subscription.user).to eq(user)
      end

      it 'must initialize' do
        uuid = SecureRandom.uuid

        subscription = Subscription.custom_create(user: { uuid: })

        expect(subscription.user).to be_new_record
        expect(subscription.user.uuid).to eq(uuid)
      end

      it 'must be empty' do
        subscription = Subscription.custom_create(user: { uuid: '' })

        expect(subscription.user).to be_new_record
        expect(subscription.user.uuid).to be_blank
      end

      it 'must be other' do
        subscription = Subscription.custom_create(user: { key: '' })

        expect(subscription.user).to be_new_record
        expect(subscription.user.uuid).to be_blank
      end

      it 'must be nil' do
        subscription = Subscription.custom_create(user: nil)

        expect(subscription.user).to be_nil
      end
    end

    context 'with id' do
      let(:subscription) { create(:subscription).reload }

      it 'must find' do
        collaborator = Collaborator.custom_create(subscription: { id: subscription.id })

        expect(collaborator.subscription).to be_persisted
        expect(collaborator.subscription).to eq(subscription)
      end

      it 'must initialize' do
        collaborator = Collaborator.custom_create(subscription: { id: 0 })

        expect(collaborator.subscription).to be_new_record
        expect(collaborator.subscription.id).to eq(0)
      end

      it 'must be empty id' do
        collaborator = Collaborator.custom_create(subscription: { id: '' })

        expect(collaborator.subscription).to be_new_record
        expect(collaborator.subscription.id).to be_blank
      end

      it 'must be empty othe' do
        collaborator = Collaborator.custom_create(subscription: { key: '' })

        expect(collaborator.subscription).to be_new_record
        expect(collaborator.subscription.id).to be_blank
      end

      it 'must be nil' do
        collaborator = Collaborator.custom_create(subscription: nil)

        expect(collaborator.subscription).to be_nil
      end
    end

    context 'with token' do
      let(:notificator) { create(:notificator).reload }

      it 'must find' do
        collaborator = Notification.custom_create(notificator: { token: notificator.token })

        expect(collaborator.notificator).to be_persisted
        expect(collaborator.notificator).to eq(notificator)
      end

      it 'must initialize' do
        collaborator = Notification.custom_create(notificator: { token: '0' })

        expect(collaborator.notificator).to be_new_record
        expect(collaborator.notificator.token).to eq('0')
      end

      it 'must be empty token' do
        collaborator = Notification.custom_create(notificator: { token: '' })

        expect(collaborator.notificator).to be_new_record
        expect(collaborator.notificator.token).to be_blank
      end

      it 'must be empty othe' do
        collaborator = Notification.custom_create(notificator: { key: '' })

        expect(collaborator.notificator).to be_new_record
        expect(collaborator.notificator.token).to be_blank
      end

      it 'must be nil' do
        collaborator = Notification.custom_create(notificator: nil)

        expect(collaborator.notificator).to be_nil
      end
    end
  end

  describe '.custom_update' do
    context 'with uuid' do
      let(:user) { create(:user).reload }
      let(:subscription) { create(:subscription) }

      it 'must find' do
        subscription.custom_update(user: { uuid: user.uuid })

        expect(subscription.user).to be_persisted
        expect(subscription.user).to eq(user)
      end

      it 'must initialize' do
        uuid = SecureRandom.uuid

        subscription.custom_update(user: { uuid: })

        expect(subscription.user).to be_new_record
        expect(subscription.user.uuid).to eq(uuid)
      end

      it 'must be empty uuid' do
        subscription.custom_update(user: { uuid: '' })

        expect(subscription.user).to be_new_record
        expect(subscription.user.uuid).to be_blank
      end

      it 'must be empty other' do
        subscription.custom_update(user: { key: '' })

        expect(subscription.user).to be_new_record
        expect(subscription.user.uuid).to be_blank
      end

      it 'must be nil' do
        subscription.custom_update(user: nil)

        expect(subscription.user).to be_nil
      end
    end

    context 'with id' do
      let(:subscription) { create(:subscription) }
      let(:collaborator) { create(:collaborator) }

      it 'must find' do
        collaborator.custom_update(subscription: { id: subscription.id })

        expect(collaborator.subscription).to be_persisted
        expect(collaborator.subscription).to eq(subscription)
      end

      it 'must initialize' do
        collaborator.custom_update(subscription: { id: 0 })

        expect(collaborator.subscription).to be_new_record
        expect(collaborator.subscription.id).to eq(0)
      end

      it 'must be empty id' do
        collaborator.custom_update(subscription: { id: '' })

        expect(collaborator.subscription).to be_new_record
        expect(collaborator.subscription.id).to be_blank
      end

      it 'must be empty other' do
        collaborator.custom_update(subscription: { key: '' })

        expect(collaborator.subscription).to be_new_record
        expect(collaborator.subscription.id).to be_blank
      end

      it 'must be nil' do
        collaborator.custom_update(subscription: nil)

        expect(collaborator.subscription).to be_nil
      end
    end

    context 'with token' do
      let(:notificator) { create(:notificator, name: 'Notificator 2') }
      let(:notification) { create(:notification) }

      it 'must find' do
        notification.custom_update(notificator: { token: notificator.token })

        expect(notification.notificator).to be_persisted
        expect(notification.notificator).to eq(notificator)
      end

      it 'must initialize' do
        notification.custom_update(notificator: { token: '0' })

        expect(notification.notificator).to be_new_record
        expect(notification.notificator.token).to eq('0')
      end

      it 'must be empty token' do
        notification.custom_update(notificator: { token: '' })

        expect(notification.notificator).to be_new_record
        expect(notification.notificator.token).to be_blank
      end

      it 'must be empty other' do
        notification.custom_update(notificator: { key: '' })

        expect(notification.notificator).to be_new_record
        expect(notification.notificator.token).to be_blank
      end

      it 'must be nil' do
        notification.custom_update(notificator: nil)

        expect(notification.notificator).to be_nil
      end
    end
  end

  it '#searchable_attributes' do
    expect(User.new.send(:searchable_attributes)).to eq(%i[email name])
  end

  it '#after_save_configure_searchable' do
    subscription = create(:subscription, name: ' NÀME 01 ')
    expect(subscription.reload.searchable_name).to eq('name 01')

    subscription.update!(name: ' NÀME 02 ')
    expect(subscription.reload.searchable_name).to eq('name 02')
  end

  it '#before_validation_subscription_current_records_count' do
    called = build(:called, subscription: create(:subscription, current_records_count: 1_000))

    called.valid?

    expect(called.errors.details[:subscription]).to include(error: :subscription_current_records_count, value: 1_000)
  end

  it '#before_validation_subscription_due_date' do
    called = build(:called, subscription: create(:subscription, due_date: Date.yesterday))

    called.valid?

    expect(called.errors.details[:subscription]).to include(error: :subscription_due_date, value: I18n.l(Date.yesterday))
  end

  it '#after_save_subscription_current_records_count' do
    subscription = create(:subscription)

    expect do
      create(:called, subscription:)
      create(:webhook, subscription:)
    end.to change {
             [subscription.current_records_count, subscription.calleds_count, subscription.webhooks_count]
           }.from([7, 0, 0]).to([9, 1, 1])
  end

  it '#after_destroy_subscription_current_records_count' do
    subscription = create(:subscription)
    called = create(:called, subscription:)
    webhook = create(:webhook, subscription:)

    expect do
      called.destroy!
      webhook.destroy!
      subscription.fields.destroy_all
    end.to change {
             [subscription.current_records_count, subscription.calleds_count, subscription.webhooks_count]
           }.from([9, 1, 1]).to([0, 0, 0])
  end

  it '#respond_to_missing?' do
    expect(Vehicle.new.send(:respond_to_missing?, :field_brands)).to be_truthy
    expect(Vehicle.new.send(:respond_to_missing?, :field_ids)).to be_falsey
  end

  it '#method_missing' do
    vehicle = Vehicle.new

    expect(vehicle).to receive(:field_).with(:brands)

    vehicle.send(:method_missing, :field_brands)
  end

  it '#field_' do
    vehicle = Vehicle.new

    expect(vehicle.send(:field_, :brands)).to eq([])
    expect(vehicle.send(:field_, :models)).to eq([])
    expect(vehicle.instance_variable_get(:@field_)).to eq(brands: nil, models: nil)

    vehicle.subscription = create(:subscription)
    expect(vehicle.send(:field_, :brands)).to eq(%w[FIAT])
    expect(vehicle.instance_variable_get(:@field_)).to eq(brands: %w[FIAT], models: nil)
  end
end
