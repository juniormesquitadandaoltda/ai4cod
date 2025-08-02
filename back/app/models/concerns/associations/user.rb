module Associations
  module User
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail only: %i[
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
      ]

      devise :database_authenticatable, :async, :registerable,
             :recoverable, :rememberable, :validatable,
             :confirmable, :lockable, :timeoutable, :trackable

      has_many :audits, foreign_key: :owner_id, dependent: :restrict_with_error
      has_many :subscriptions, dependent: :restrict_with_error
      has_many :collaborations, class_name: 'Collaborator', dependent: :restrict_with_error
      has_many :facilitators, foreign_key: :email, primary_key: :email, dependent: :nullify
      has_many :proprietors, foreign_key: :email, primary_key: :email, dependent: :nullify

      def tasks
        ::Task.where(proprietors:).or(::Task.where(facilitators:)).where(shared: true)
      end
    end
  end
end
