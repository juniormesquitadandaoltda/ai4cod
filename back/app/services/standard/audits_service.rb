module STANDARD
  class AuditsService < ApplicationService
    attr_accessor :audit

    validates :audit, presence: true, persistence: true

    private

    def run
      webhooks.find_each do |webhook|
        request(webhook)
      end

      @result = true
    end

    def webhooks
      ::Webhook.joins(:subscription).where(
        subscriptions: { user_id: audit.owner_id },
        event: audit.event,
        actived: true
      )
    end

    def request(webhook)
      body = body(webhook)
      status = post(url: webhook.url, body:)
      update(webhook:, body:, status:)
    end

    def body(webhook)
      {
        resource: webhook.resource,
        event: webhook.event,
        id: audit.item_id,
        idempotent: audit.id
      }
    end

    def post(url:, body:)
      ::Faraday.new(request: { timeout: 1 }).post(url, body.to_json, {
                                                    user_agent: 'AI for Code .COM',
                                                    accept: 'application/json',
                                                    content_type: 'application/json'
                                                  }).status
    end

    def update(webhook:, body:, status:)
      webhook.update_columns(
        request_metadata: {
          url: webhook.url,
          body:,
          status:
        },
        requested_at: Time.current,
        actived: status.between?(200, 299)
      )
      webhook.increment!(:requests_count)
    end
  end
end
