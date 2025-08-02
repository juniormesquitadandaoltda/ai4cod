module ADMIN
  class TasksFilter < ApplicationFilter
    MODEL = ::Task

    search_attributes(
      string: %i[name subscription_name vehicle_plate],
      field_enum: %i[stage next_stage],
      date: %i[scheduling_at],
      boolean: %i[shared],
      key: %i[subscription_id vehicle_id]
    )

    private

    def select
      %i[
        id
        name
        stage
        next_stage
        scheduling_at
        shared
        vehicle_id
        vehicle_plate
        subscription_id
        subscription_name
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'vehicles.plate AS vehicle_plate',
        'vehicles.searchable_plate AS searchable_vehicle_plate',
        'subscriptions.name AS subscription_name',
        'subscriptions.searchable_name AS searchable_subscription_name'
      ).joins(:subscription, :vehicle).to_sql
    end
  end
end
