require 'rails_helper'

RSpec.describe Audit, type: :model do
  it { is_expected.to be_is_a(::PaperTrail::Version) }
end
