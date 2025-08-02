json.openapi '3.0.3'
json.info do
  json.title 'Login'
  json.description 'AI for Code .COM'
  json.version 'current'
end
json.servers [{ url: 'http://dockerhost:3000' }]

tags = []
paths = {}

swagger_helper(:login).each do |openapi|
  controller = openapi[:controller]

  tag = if controller == '/login/registrations'
          url_for(controller:, action: :edit).split('/edit').first
        else
          url_for(controller:, action: :new).split('/new').first
        end

  tags << tag

  openapi[:actions].each do |action|
    method = { index: :get, show: :get, new: :get, edit: :get, create: :post, update: :put, destroy: :delete }[action]

    path = url_for(controller:, action:)
    paths[path] ||= {}
    paths[path].merge!(
      method => {
        tags: [tag],
        requestBody: {
          content: {
            'application/json': {
              schema: {
                example: {}
              }
            }
          }
        },
        responses: {
          '200': {
            description: 'Ok',
            content: {
              'application/json': {
                schema: {
                  example: {}
                }
              }
            }
          },
          '422': {
            description: 'Unprocessable Entity',
            content: {
              'application/json': {
                schema: {
                  example: {}
                }
              }
            }
          }
        }
      }
    )
  end
end

json.tags tags
json.paths paths
