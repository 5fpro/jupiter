class DatetimeService

  class << self

    def to_units_text(time, skip_second: false, skip_day: false)
      results = []
      { day: 1.day, hour: 1.hour, minute: 1.minute, second: 1.second }.each do |key, unit|
        next if skip_second && key == :second
        next if skip_day && key == :day
        if time > unit
          results << I18n.t("datetime.distance_in_words.x_#{key}s", count: (time / unit).to_i)
          time = time % unit
        end
      end
      results.join(' ')
    end

  end
end
