module ADMIN
  class ApplicationPolicy
    attr_reader :user, :owner, :params

    def initialize(pundit_user, _ = nil)
      @user = pundit_user[:user]
      @owner = pundit_user[:owner]
      @params = pundit_user[:params]
    end

    private

    def admin?
      user.profile_admin?
    end
  end
end
