class Notify::Event
  class << self
    def all
      [:record_created]
    end

    def descs
      collection.map(&:first)
    end

    def collection
      all.map { |e| [I18n.t("models.slack_channel.events.#{e}"), e] }
    end
  end
end
