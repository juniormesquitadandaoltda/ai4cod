require 'rails_helper'

Dir.glob('config/locales/**/*.yml') do |locale_file|
  RSpec.describe locale_file do
    it { is_expected.to be_parseable }
    it { is_expected.to have_valid_pluralization_keys }
    it { is_expected.not_to have_missing_pluralization_keys }
    it { is_expected.to have_one_top_level_namespace }
    it { is_expected.not_to have_legacy_interpolations }
    it { is_expected.to have_a_valid_locale }
  end
end
