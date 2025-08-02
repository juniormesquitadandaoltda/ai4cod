require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views

  describe 'GET index' do
    it '.json default' do
      get :index, format: :json
    end
  end
end
