class Search::Record < ::Record

  CREATED_AT_PERIODS = [:this_week, :last_week, :this_month, :last_month].freeze

  class << self
    def ransackable_scopes(_auth_object = nil)
      [:record_type_key_in, :created_at_period_is]
    end

    def record_type_key_in(*values)
      values = values.select(&:present?).map{ |v| self.record_types[v.to_sym] }
      where(record_type: values)
    end

    def created_at_period_is(period)
      case period.to_sym
      when :this_week then where(created_at: Time.now.beginning_of_week..Time.now.end_of_week)
      when :last_week then where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
      when :this_month then where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
      when :last_month then where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
      end
    end

    def created_at_collection
      CREATED_AT_PERIODS.map{ |key| [I18n.t("models.record.created_at_periods.#{key}"), key] }
    end
  end

end
