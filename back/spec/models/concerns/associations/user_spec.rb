require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }

    it {
      expect(described_class.paper_trail_options[:only].map(&:to_sym)).to eq(%i[
        email

        current_sign_in_at
        last_sign_in_at
        current_sign_in_ip
        last_sign_in_ip

        locked_at

        name
        profile
        status
        timezone
        locale

        policy_terms
      ])
    }
  end

  describe '.has_many' do
    it { is_expected.to have_many(:audits).with_foreign_key(:owner_id).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:subscriptions).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:collaborations).class_name('Collaborator').dependent(:restrict_with_error) }
    it { is_expected.to have_many(:proprietors).with_foreign_key(:email).with_primary_key(:email).dependent(:nullify) }
    it { is_expected.to have_many(:facilitators).with_foreign_key(:email).with_primary_key(:email).dependent(:nullify) }
  end

  it '#tasks' do
    user = create(:user)
    task = create(:task)

    expect(user.tasks).to eq([])

    user.update_column(:email, task.proprietor.email)
    expect(user.reload.tasks).to eq([task])
    task.update_column(:shared, false)
    expect(user.reload.tasks).to eq([])

    task.update_column(:shared, true)

    user.update_column(:email, task.facilitator.email)
    expect(user.reload.tasks).to eq([task])
    task.update_column(:shared, false)
    expect(user.reload.tasks).to eq([])
  end
end
