module ApplicationHelper
  def collection_for_record_types
    Record.record_types.keys.map do |key|
      [ record_type_name(key), Record.record_types[key] ]
    end
  end

end
