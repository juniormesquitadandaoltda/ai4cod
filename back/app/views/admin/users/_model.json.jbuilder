model = @model || controller.class::MODEL.new

json.model do
  json.extract! model, :id, :uuid, :email, :name, :timezone, :locale, :status, :profile
  json.extract! model, :sign_in_count, :current_sign_in_ip, :last_sign_in_ip
  json.extract! model, :unconfirmed_email, :failed_attempts, :subscriptions_count, :collaborations_count

  %i[
    reset_password_sent_at remember_created_at current_sign_in_at last_sign_in_at confirmed_at
    confirmation_sent_at locked_at destroyed_at
  ].each do |attribute|
    json.set! attribute, model.send(attribute)&.to_api
  end

  json.created_at model.created_at&.to_api
  json.updated_at model.updated_at&.to_api
end
