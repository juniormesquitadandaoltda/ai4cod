class HomeController < PUBLIC::ApplicationController
  def index
    @count = Task.last&.id || 1_000
  end
end
