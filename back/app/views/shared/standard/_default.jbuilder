pages = [
  { title: 'Home', method: 'get', url: home_path },
  { title: 'Login', method: 'get', url: edit_login_registration_path },
  { title: t('view.page.session.title'), method: 'get', url: standard_session_path }
]

pages.push({ title: Subscription.model_name.human, method: 'get', url: standard_subscription_path }, { title: Audit.model_name.human, method: 'get', url: standard_audits_path }) if authorized_application_helper?(:'standard/subscriptions', :show)

pages.unshift(title: 'Mail', method: 'get', url: letter_opener_web_path, target: '_blank') if Rails.env.development?

extra_pages = (
  if controller.current_subscription
    %i[
      calleds
      collaborators
      webhooks
      fields
      proprietors
      facilitators
      vehicles
      tasks
      archives
    ]
  elsif controller.client? && controller.current_user.tasks.any?
    %i[
      tasks
    ]
  else
    []
  end
).sort.map do |controller|
  title = controller.to_s.classify.safe_constantize.model_name.human(count: 2)
  {
    title:,
    method: 'get',
    url: url_for(controller: "/standard/#{controller}", action: :index, only_path: true)
  }
end.sort_by { |page| page[:title] }

json.pages pages + extra_pages
json.extract! current_user, :locale, :timezone
json.authenticity_token form_authenticity_token
json.set! :error, {}
json.how_to I18n.t!("how_to.#{controller_path}.#{action_name}")
