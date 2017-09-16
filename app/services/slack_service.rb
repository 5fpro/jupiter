class SlackService
  WEBHOOK = 'https://hooks.slack.com/services/xxxxx/xxxx'.freeze
  DEFAULT_ICON_URL = 'http://i.imgur.com/4G30GGh.jpg'.freeze

  class << self
    def notify(message, channel: '#general', name: 'Jupiter', icon_url: DEFAULT_ICON_URL, webhook: nil)
      name = 'Jupiter' if name.blank?
      icon_url = DEFAULT_ICON_URL if icon_url.blank?
      notify = Slack::Notifier.new(webhook || WEBHOOK, channel: channel, username: name)
      message = "[#{Rails.env}] #{message}" unless Rails.env.production?
      notify.ping(message, icon_url: icon_url)
    end

    def notify_async(message, channel: '#general', name: 'slackbot', icon_url: DEFAULT_ICON_URL, webhook: nil)
      SlackNotifyJob.perform_later(message, channel: channel, name: name, icon_url: icon_url, webhook: webhook)
    end

    def notify_admin(message, channel = 'jupiter-notify')
      webhook = 'https://hooks.slack.com/services/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'
      notify_async(message, channel: channel, name: 'Jupiter', icon_url: 'http://i.imgur.com/4G30GGh.jpg', webhook: webhook)
    end

    # see more message formating:
    #   https://api.slack.com/docs/formatting
    def render_link(link, message = nil)
      message ||= link
      "<#{link}|#{message}>"
    end
  end

end
