class BaseResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # Redirects resources to the collection path (index action) instead
  # of the resource path (show action) for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder

  def json_resource_errors
    {
      alert: controller.alert,
      error: resource.errors.messages.reduce({}) { |h, (k, v)| h.merge!(k => v.first) },
      locale: I18n.locale,
      timezone: Time.zone.name
    }
  end

  def to_json(*_args)
    set_flash_message!
    to_format
  end

  def to_format
    if has_errors? && !response_overridden?
      display_errors
    elsif has_view_rendering? || response_overridden?
      default_render
    else
      api_behavior
    end
  rescue ActionView::MissingTemplate
    api_behavior
  end

  def set_flash_now?
    true
  end
end
