module ApplicationHelper
  def authorized_application_helper?(controller, action, params = {})
    instance = policy(controller.to_sym)
    instance.params.merge!(params)
    instance.respond_to?(action) ? instance.send(action) : false
  end
end
