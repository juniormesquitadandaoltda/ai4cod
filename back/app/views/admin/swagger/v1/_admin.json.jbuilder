json.openapi '3.0.3'
json.info do
  json.title 'Admin'
  json.description 'AI for Code .COM'
  json.version 'current'
end
json.servers [{ url: 'http://dockerhost:3000' }]

tags = []
paths = {}

swagger_helper(:admin).each do |openapi|
  controller = openapi[:controller]

  actions = openapi[:actions]
  tag_action = actions.include?(:index) ? :index : :show

  tag = url_for(controller:, action: tag_action)
  tags << tag

  openapi[:actions].each do |action|
    method = { index: :get, show: :get, new: :get, edit: :get, create: :post, update: :put, destroy: :delete, personificate: :put }[action]

    params = %i[show edit update destroy personificate].include?(action) && controller != '/admin/sessions' ? { id: ':id' } : {}

    path = url_for(controller:, action:, **params)
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
