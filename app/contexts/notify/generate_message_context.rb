class Notify::GenerateMessageContext < BaseContext
  include RecordHelper

  before_perform :to_params

  def initialize(event, objects = {})
    @event = event.to_s
    @objects = objects
  end

  def perform
    run_callbacks :perform do
      I18n.t("contexts.notify.event-messages.#{@event}", @params)
    end
  end

  private

  # TODO: should use factory pattern
  def to_params
    @params = send("to_params_#{@event}")
  end

  def to_params_record_created
    record = @objects[:record]
    { record_id: record.id,
      project_name: record.project.name,
      user_name: record.user.name,
      time: render_hours(record.total_time),
      record_type_name: record_type_name(record.record_type)
    }
  end

  def to_params_approach_hours_limit
    project = @objects[:project]
    { project_name: project.name,
      limit_hours: render_hours(project.hours_limit.hours),
      current_hours: render_hours(project.records.this_month.total_time)
    }
  end
end
