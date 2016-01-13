module RecordHelper
  def record_type_name(record_type)
    t("models.record.record_types.#{record_type}")
  end
end
