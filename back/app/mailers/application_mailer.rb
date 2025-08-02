class ApplicationMailer < ActionMailer::Base
  self.deliver_later_queue_name = 'mailer'

  layout 'mailer'

  default from: 'AI for Code .COM <dont.reply@ai4cod.com>'

  def mail(headers = {}, &block)
    return if empty_or_bounce_or_complaint?(headers[:to])

    super(headers, &block)
  end

  private

  def empty_or_bounce_or_complaint?(email)
    email.blank? || Notification.where(
      "body->>'notificationType' IN (?)", %w[Bounce Complaint]
    ).where(
      "body->'mail'->'destination'->>0 = ?", email
    ).exists?
  end
end
