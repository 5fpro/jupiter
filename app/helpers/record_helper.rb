module RecordHelper
  def record_type_name(record_type)
    I18n.t("models.record.record_types.#{record_type}") if record_type.present?
  end

  def render_hours(time)
    DatetimeService.to_units_text(time, skip_day: true)
  end
end
