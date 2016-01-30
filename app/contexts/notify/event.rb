class Notify::Event
  class << self
    def all
      [:record_created]
    end

    def descs
      collection.map(&:first)
    end

    def collection
      all.map { |e| [desc(e), e] }
    end

    def desc(event)
      I18n.t("models.slack_channel.events.#{event}")
    end
  end
end
