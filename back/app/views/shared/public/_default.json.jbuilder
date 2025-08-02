pages = [
  { title: 'Home', method: 'get', url: home_path }
]

pages.unshift(title: 'Mail', method: 'get', url: letter_opener_web_path, target: '_blank') if Rails.env.development?

json.pages pages
json.locale I18n.locale.to_s
json.timezone Time.zone.name
