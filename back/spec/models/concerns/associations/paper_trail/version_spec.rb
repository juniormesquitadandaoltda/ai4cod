require 'rails_helper'

module PaperTrail
  RSpec.describe Version, type: :model do
    describe '.has_paper_trail' do
      it { is_expected.not_to be_versioned }
    end

    describe '.include' do
      it { is_expected.to be_is_a(::PaperTrail::VersionConcern) }
    end

    it '.table_name' do
      expect(described_class.table_name.to_sym).to eq(:audits)
    end

    describe '.belongs_to' do
      it { is_expected.to belong_to(:item).required }
      it { is_expected.to belong_to(:whodunnit).class_name('User').required }
      it { is_expected.to belong_to(:owner).class_name('User').required }
    end

    describe '.enum' do
      it {
        expect(subject).to define_enum_for(:event).with_values(
          %i[create update destroy].reduce({}) { |h, v| h.merge!(v => v.to_s) }
        ).with_prefix.backed_by_column_of_type('string')
      }
    end
  end
end
