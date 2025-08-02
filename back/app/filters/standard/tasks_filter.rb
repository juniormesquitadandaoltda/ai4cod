module STANDARD
  class TasksFilter < ApplicationFilter
    MODEL = ::Task

    search_attributes(
      string: %i[name vehicle_plate],
      field_enum: %i[stage next_stage],
      date: %i[scheduling_at],
      boolean: %i[shared],
      key: %i[vehicle_id]
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
        created_at
        updated_at
      ]
    end

    def sql
      if current_subscription
        MODEL.unscoped.select(
          *column_names,
          'vehicles.plate AS vehicle_plate',
          'vehicles.searchable_plate AS searchable_vehicle_plate'
        ).joins(:vehicle).where(
          subscription: current_subscription
        ).to_sql
      else
        MODEL.unscoped.select(
          *column_names,
          'vehicles.plate AS vehicle_plate',
          'vehicles.searchable_plate AS searchable_vehicle_plate'
        ).where(
          proprietor: current_user.proprietors
        ).or(
          MODEL.unscoped.where(
            facilitator: current_user.facilitators
          )
        ).joins(:vehicle).where(shared: true).to_sql
      end
    end
  end
end
