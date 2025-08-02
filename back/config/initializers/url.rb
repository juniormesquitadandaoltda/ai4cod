require 'action_dispatch/http/url'

# /usr/local/bundle/gems/actionpack-7.0.4.3/lib/action_dispatch/http/url.rb
class << ActionDispatch::Http::URL
  def full_url_for(options)
    full_path = options.delete(:full_path)

    host     = options[:host] || Rails.configuration.action_mailer.default_url_options[:host]
    protocol = options[:protocol] || Rails.configuration.action_mailer.default_url_options[:protocol]
    port     = options[:port] || Rails.configuration.action_mailer.default_url_options[:port]

    raise ArgumentError, 'Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true' unless host

    if full_path
      build_host_url(host, port, protocol, options, path_for(options))
    else
      build_host_url(host, port, protocol, options, path_for(options)).gsub('/data', '')
    end
  end

  def path_for(options)
    full_path = options.delete(:full_path)

    path = options[:script_name].to_s.chomp('/')
    path << options[:path] if options.key?(:path)

    path = '/' if options[:trailing_slash] && path.blank?

    add_params(path, options[:params]) if options.key?(:params)
    add_anchor(path, options[:anchor]) if options.key?(:anchor)

    if full_path
      path
    else
      path.gsub('/data', '').presence || '/'
    end
  end
end
