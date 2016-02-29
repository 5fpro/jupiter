class TodoPublishContext < BaseContext
  include RecordHelper

  before_perform :find_todos
  before_perform :to_messages
  before_perform :append_total_hours
  before_perform :slack_setting

  def initialize(user)
    @user = user
  end

  def perform
    run_callbacks :perform do
      SlackService.notify_async(@messages.join("\n"), @slack_setting)
    end
  end

  private

  def find_todos
    @done_todos = @user.todos.project_sorted.today_done.includes(:project)
    @not_done_todos = @user.todos.project_sorted.not_done.includes(:project)
  end

  def to_messages
    @messages = ["#{@user.name} 本日工作報告:", ""]
    { "[今日已完成]" => @done_todos, "[明日預定]" => @not_done_todos }.each do |title, todos|
      @messages << title
      todos.each do |todo|
        msg = "#{todo.project.name} - #{todo.desc}"
        msg = "#{msg} (#{render_hours(todo.total_time)})" if todo.total_time > 0
        @messages << msg
      end
      @messages << ""
    end
  end

  def append_total_hours
    @messages << "今日累積工時: #{render_hours @user.records.today.total_time}"
    @messages << "本月累積工時: #{render_hours @user.records.this_month.total_time}"
  end

  # TODO: team
  def slack_setting
    @slack_setting = { channel: "#standup-meeting", webhook: "https://hooks.slack.com/services/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" }
  end
end
