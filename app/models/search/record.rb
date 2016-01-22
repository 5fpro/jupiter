class Search::Record < ::Record

  class << self
    def ransackable_scopes(_auth_object = nil)
      [:record_type_key_in]
    end

    def record_type_key_in(*values)
      values = values.select(&:present?).map{ |v| self.record_types[v.to_sym] }
      where(record_type: values)
    end
  end

end
