module PathHelper
  def path_helper(params:, controller:, action:, id: nil)
    controller = controller.to_s.dup
    controller.gsub!('admin/', '')
    controller.gsub!('standard/', '')
    controller.gsub!('login/', '')

    new_params = { controller: "/#{current_user&.profile || 'login'}/#{controller}", action:, only_path: true }

    new_params = params.dup.except(:id).dup.permit!.merge(new_params) if params[:controller].to_s.end_with?(controller) && %i[index show edit].include?(action) && !%w[login session].find { |c| controller.include?(c) }

    if %i[index_archives new_archives].include?(action)
      new_params.merge!(
        action: action.to_s.split('_').first.to_sym,
        controller: "/#{current_user&.profile || 'login'}/archives",
        record_id: id,
        record_type: controller.singularize.classify
      )
    elsif id
      new_params.merge!(id:)
    end

    {
      url: url_for(new_params),
      title: t("view.path.#{action}.title"),
      name: action
    }.merge(
      send(:"#{action}_path_helper", id)
    )
  end

  private

  def index_path_helper(_id)
    { method: 'get' }
  end

  def index_archives_path_helper(_id)
    { method: 'get', target: '_blank' }
  end

  def show_path_helper(_id)
    { method: 'get' }
  end

  def new_path_helper(_id)
    { method: 'get' }
  end

  def new_archives_path_helper(_id)
    { method: 'get', target: '_blank' }
  end

  def edit_path_helper(_id)
    { method: 'get' }
  end

  def create_path_helper(_id)
    { method: 'post' }
  end

  def update_path_helper(_id)
    { method: 'put' }
  end

  def personificate_path_helper(id)
    { method: 'put', message: t('view.path.personificate.message', id:) }
  end

  def destroy_path_helper(id)
    { method: 'delete', message: t('view.path.destroy.message', id:) }
  end

  def export_path_helper(_id)
    { method: 'patch', message: t('view.path.export.message') }
  end

  def preview_path_helper(_id)
    { method: 'get', target: '_blank' }
  end
end
