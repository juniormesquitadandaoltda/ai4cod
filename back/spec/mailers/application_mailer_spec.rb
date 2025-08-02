require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  let!(:notificator) { create(:notificator) }

  let!(:bounce) do
    create(:notification,
           url: "https://ai4cod.com/data/public/notificators/#{notificator.token}/notifications",
           headers: {
             HTTP_HOST: 'ai4cod.com'
           },
           body: {
             "notificationType": 'Bounce', "bounce": { "feedbackId": '010001887a46d74c-16a0f58f-b0e7-458e-a52f-0468bbd0e605-000000', "bounceType": 'Permanent', "bounceSubType": 'General', "bouncedRecipients": [{ "emailAddress": 'bounce@simulator.amazonses.com', "action": 'failed', "status": '5.1.1', "diagnosticCode": 'smtp; 550 5.1.1 user unknown' }], "timestamp": '2023-06-02T04:04:03.000Z', "remoteMtaIp": '54.84.101.226', "reportingMTA": 'dns; a8-45.smtp-out.amazonses.com' }, "mail": { "timestamp": '2023-06-02T04:04:02.542Z', "source": 'dont.reply@ai4cod.com', "callerIdentity": 'root', "sendingAccountId": '495775800339', "messageId": '010001887a46d56e-1cc112b0-07f4-4fd2-b4d1-ac5076c8af7b-000000', "destination": ['bounce@simulator.amazonses.com'], "headersTruncated": false, "headers": [{ "name": 'From', "value": 'dont.reply@ai4cod.com' }, { "name": 'To', "value": 'bounce@simulator.amazonses.com' }, { "name": 'Subject', "value": 'bounce' }, { "name": 'MIME-Version', "value": '1.0' }, { "name": 'Content-Type', "value": '2282086_1370210354.1685678642545' }], "commonHeaders": { "from": ['dont.reply@ai4cod.com'], "to": ['bounce@simulator.amazonses.com'], "subject": 'bounce' } }
           },
           notificator:)
  end

  let!(:complaint) do
    create(:notification,
           url: "https://ai4cod.com/data/public/notificators/#{notificator.token}/notifications",
           headers: {
             HTTP_HOST: 'ai4cod.com'
           },
           body: {
             "notificationType": 'Complaint', "complaint": { "feedbackId": '010001887a487508-b979c9ea-0599-48a0-9df2-30bcac3f0655-000000', "complaintSubType": nil, "complainedRecipients": [{ "emailAddress": 'complaint@simulator.amazonses.com' }], "timestamp": '2023-06-02T04:05:49.000Z', "userAgent": 'Amazon SES Mailbox Simulator', "complaintFeedbackType": 'abuse', "arrivalDate": '2023-06-02T04:05:49.145Z' }, "mail": { "timestamp": '2023-06-02T04:05:48.200Z', "source": 'dont.reply@ai4cod.com', "sourceArn": 'arn:aws:ses:us-east-1:495775800339:identity/ai4cod.com', "sourceIp": '45.175.128.38', "callerIdentity": 'root', "sendingAccountId": '495775800339', "messageId": '010001887a487228-b6005be7-f299-473d-9949-9307f8ec03d4-000000', "destination": ['complaint@simulator.amazonses.com'], "headersTruncated": false, "headers": [{ "name": 'From', "value": 'dont.reply@ai4cod.com' }, { "name": 'To', "value": 'complaint@simulator.amazonses.com' }, { "name": 'Subject', "value": 'complaint' }, { "name": 'MIME-Version', "value": '1.0' }, { "name": 'Content-Type', "value": '2278210_921667478.1685678748204' }], "commonHeaders": { "from": ['dont.reply@ai4cod.com'], "to": ['complaint@simulator.amazonses.com'], "subject": 'complaint' } }
           },
           notificator:)
  end

  let!(:delivery) do
    create(:notification,
           url: "https://ai4cod.com/data/public/notificators/#{notificator.token}/notifications",
           headers: {
             HTTP_HOST: 'ai4cod.com'
           },
           body: {
             "notificationType": 'Delivery', "mail": { "timestamp": '2023-06-02T04:10:10.414Z', "source": 'dont.reply@ai4cod.com', "callerIdentity": 'root', "sendingAccountId": '495775800339', "messageId": '010001887a4c726e-5fa62fa6-50ac-4546-8356-42b26cd2f957-000000', "destination": ['success@simulator.amazonses.com'], "headersTruncated": false, "headers": [{ "name": 'From', "value": 'dont.reply@ai4cod.com' }, { "name": 'To', "value": 'success@simulator.amazonses.com' }, { "name": 'Subject', "value": 'success' }, { "name": 'MIME-Version', "value": '1.0' }, { "name": 'Content-Type', "value": '2277738_441985068.1685679010418' }], "commonHeaders": { "from": ['dont.reply@ai4cod.com'], "to": ['success@simulator.amazonses.com'], "subject": 'success' } }, "delivery": { "timestamp": '2023-06-02T04:10:10.855Z', "processingTimeMillis": 441, "recipients": ['success@simulator.amazonses.com'], "smtpResponse": '250 2.6.0 Message received', "remoteMtaIp": '52.87.53.168', "reportingMTA": 'a48-132.smtp-out.amazonses.com' }
           },
           notificator:)
  end

  let!(:new) do
    create(:notification,
           url: "https://ai4cod.com/data/public/notificators/#{notificator.token}/notifications",
           headers: {
             HTTP_HOST: 'ai4cod.com'
           },
           body: {
             "key": 'value'
           },
           notificator:)
  end

  it '.empty_or_bounce_or_complaint?' do
    expect(subject.send(:empty_or_bounce_or_complaint?, 'bounce@simulator.amazonses.com')).to be_truthy
    expect(subject.send(:empty_or_bounce_or_complaint?, 'complaint@simulator.amazonses.com')).to be_truthy
    expect(subject.send(:empty_or_bounce_or_complaint?, ' ')).to be_truthy
    expect(subject.send(:empty_or_bounce_or_complaint?, nil)).to be_truthy

    expect(subject.send(:empty_or_bounce_or_complaint?, 'success@simulator.amazonses.com')).to be_falsey
    expect(subject.send(:empty_or_bounce_or_complaint?, 'user@email.com')).to be_falsey
  end
end
