class ApplicationService
  include ::ActiveModel::Model

  attr_reader :result

  def call
    valid? && run
    errors.empty?
  end

  private

  def run; end
end
