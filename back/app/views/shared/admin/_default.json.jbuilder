pages = [
  { title: 'Sidekiq', method: 'get', url: sidekiq_web_path, target: '_blank' },
  { title: 'Swagger', method: 'get', url: rswag_ui_path, target: '_blank' },
  { title: 'Home', method: 'get', url: home_path },
  { title: 'Login', method: 'get', url: edit_login_registration_path },
  { title: t('view.page.session.title'), method: 'get', url: admin_session_path },
  { title: Subscription.model_name.human(count: 2), method: 'get', url: admin_subscriptions_path },
  { title: Audit.model_name.human(count: 2), method: 'get', url: admin_audits_path },
  { title: User.model_name.human(count: 2), method: 'get', url: admin_users_path },
  { title: Notificator.model_name.human(count: 2), method: 'get', url: admin_notificators_path },
  { title: Notification.model_name.human(count: 2), method: 'get', url: admin_notifications_path }
]

pages.unshift(title: 'Mail', method: 'get', url: letter_opener_web_path, target: '_blank') if Rails.env.development?

extra_pages = %i[
  calleds
  collaborators
  webhooks
  fields
  proprietors
  facilitators
  vehicles
  tasks
  archives
].sort.map do |controller|
                title = controller.to_s.classify.safe_constantize.model_name.human(count: 2)
                {
                  title:,
                  method: 'get',
                  url: url_for(controller: "/admin/#{controller}", action: :index, only_path: true)
                }
              end.sort_by { |page| page[:title] }

json.pages pages + extra_pages
json.locale I18n.locale.to_s
json.timezone Time.zone.name
json.authenticity_token form_authenticity_token
json.set! :error, {}
