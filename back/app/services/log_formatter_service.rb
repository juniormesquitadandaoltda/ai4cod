class LogFormatterService < ApplicationService
  validates :controller, presence: true
  validates :request, presence: true
  validates :response, presence: true
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 400 }

  def call(_severity, _timestamp, _progname, _msg)
    valid? && run
    result
  end

  private

  def run
    @result = [
      {
        current_user: current(:user),
        current_subscription: current(:subscription),
        current_client: current(:client),
        request: {
          method: request.method,
          headers: headers(:request),
          url: request.url,
          query: request.query_parameters,
          body: request.request_parameters
        },
        response: {
          status: response.status,
          headers: headers(:response),
          body: JSON.parse(response.body.presence || '{}')
        }
      }.to_json,
      "\n"
    ].join
  end

  def controller
    NewRelic::Agent::Tracer.current_segment&.instance_variable_get(:@controller)
  end

  def request
    controller&.request
  end

  def response
    controller&.response
  end

  def status
    response&.status
  end

  def current(key)
    key = :"current_#{key}"
    controller.respond_to?(key) && controller.send(key) ? { id: controller.send(key).id } : nil
  end

  def headers(key)
    send(key)&.headers&.to_h&.select { |k, _v| (k.start_with?('HTTP_') || k.start_with?('CONTENT_')) && k.exclude?('_COOKIE') }&.reduce({}) { |h, (k, v)| h.merge(k.gsub('HTTP_', '').titleize.gsub(' ', '-') => v) }
  end
end
