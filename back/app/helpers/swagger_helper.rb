module SwaggerHelper
  def swagger_helper(route)
    swagger = []

    Dir[Rails.root.join("app/views/#{route}/*")].each do |view|
      controller = view.split('views').last

      next if %w[
        /admin/application
        /admin/swagger
        /login/mailer
        /standard/application
      ].include?(controller)

      swagger << {
        controller:,
        actions: Dir[Rails.root.join("app/views#{controller}/*")].map do |action|
          action.split(controller).last.split('.json').first.split('/').last.to_sym
        end.reject { |action| action.to_s.start_with?('_') }
      }
    end

    swagger
  end
end
