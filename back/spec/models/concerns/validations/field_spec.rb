require 'rails_helper'

RSpec.describe Field, type: :model do
  describe '.before_destroy' do
    describe 'on create' do
      subject { build(:field) }

      after { subject.save! }

      it { is_expected.not_to receive(:before_destroy_dependents!) }
    end

    describe 'on update' do
      subject { create(:field) }

      after { subject.save! }

      it { is_expected.not_to receive(:before_destroy_dependents!) }
    end

    describe 'on destroy' do
      subject { create(:field) }

      after { subject.destroy! }

      it { is_expected.to receive(:before_destroy_dependents!) }
    end
  end

  describe '.enum' do
    it {
      expect(subject).to define_enum_for(:resource).with_values(
        %i[task vehicle].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }

    it {
      expect(subject).to define_enum_for(:name).with_values(
        %i[stage brand model color fuel category kind].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }
  end

  describe '#resource' do
    it { is_expected.to validate_presence_of(:resource) }
    it { expect(create(:field)).to validate_enum_of(:resource) }
    it { expect(create(:field)).to validate_unchange_of(:resource) }
  end

  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
    it { expect(create(:field)).to validate_enum_of(:name) }
    it { expect(create(:field)).to validate_uniqueness_of(:name).scoped_to(%i[resource subscription_id]) }
    it { expect(create(:field)).to validate_unchange_of(:name) }
  end

  describe '#values' do
    it { is_expected.to validate_presence_of(:values) }

    it '#set_values!' do
      subject.values = [' ']

      subject.valid?

      expect(subject.values).to eq([])
      expect(subject.errors.details[:values]).to include(error: :blank)
    end

    it '#validate_value_taken' do
      field = create(:field)
      field.update!(values: %w[value1 value2])

      expect_any_instance_of(String).to receive(:safe_constantize).and_return(User)
      expect(User).to receive(:exists?).with(field.name => 'value1').and_return(true)
      field.update(values: %w[value2 value3])

      expect(field.errors.details[:values]).to include(error: :taken_value, value: 'value1')
    end
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }
    it { expect(create(:field)).to validate_persistence_of(:subscription) }
    it { expect(create(:field)).to validate_unchange_of(:subscription) }
  end

  it '#before_destroy_dependents!' do
    vehicle = create(:vehicle)
    field = vehicle.subscription.fields.resource_vehicle.first

    expect { field.destroy! }.to raise_exception(ActiveRecord::RecordNotDestroyed)

    expect(field.errors.details[:base]).to include(error: :"restrict_dependent_destroy.has_many", record: 'veículos')
  end
end
