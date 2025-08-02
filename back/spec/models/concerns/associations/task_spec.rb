require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }

    it {
      expect(described_class.paper_trail_options[:only].map(&:to_sym)).to eq(%i[
        name
        stage
        next_stage
        scheduling_at
        shared
        vehicle_id
        facilitator_id
        proprietor_id
      ])
    }

    it 'not must be limit' do
      user = create(:user)
      task = build(:task)

      PaperTrail.request.whodunnit = user
      with_versioning do
        task.save!

        PaperTrail.config.version_limit.times do |i|
          task.update!(name: "Name #{i}")
        end
      end

      expect(described_class.paper_trail_options[:limit]).to eq(nil)
      expect(task.versions.count).to eq(PaperTrail.config.version_limit + 1)
    end
  end

  describe '.belongs_to' do
    it { is_expected.to belong_to(:subscription).counter_cache.required }
    it { is_expected.to belong_to(:vehicle) }
    it { is_expected.to belong_to(:facilitator).optional }
    it { is_expected.to belong_to(:proprietor).optional }
  end

  describe '.has_many_attached' do
    it { is_expected.to have_many_attached(:archives) }
  end
end
