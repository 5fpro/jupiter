require 'ostruct'
class Project::GetSettlementContext < ::BaseContext
  def initialize(project, time = nil)
    @project = project
    @time = time || Time.now
  end

  def perform
    init_time!
    @records = find_records
    OpenStruct.new(
      users: users,
      each_user: each_user,
      project: project_data,
      date: "#{@start_at.year}/#{@start_at.month}"
    )
  end

  private

  def init_time!
    @time = @time.to_datetime if @time.is_a?(String)
    @start_at = @time.beginning_of_month
    @end_at = @time.end_of_month
  end

  def find_records
    @project.records.where(created_at: @start_at..@end_at).select(:user_id, :minutes).all
  end

  def project_users
    @project_users ||= @project.project_users.includes(:user).all
  end

  def users
    @users ||= project_users.map(&:user)
  end

  def each_user
    @each_user ||= project_users.inject({}) do |h, project_user|
      h.merge(project_user.user_id => build_settle_value(project_user))
    end
  end

  def project_wage
    @project.price_of_hour
  end

  def build_settle_value(project_user)
    wage = project_user.wage || project_wage
    minutes = @records.select { |r| r.user_id == project_user.user_id }.map(&:minutes).inject(&:+)
    SettleValue.new(wage: wage, project_wage: project_wage, minutes: minutes)
  end

  def project_data
    income = @each_user.values.map(&:income).map(&:to_i).inject(&:+) || 0
    project_hours = project_wage ? (income.to_f / project_wage).round(2) : 0
    minutes = @each_user.values.map(&:minutes).map(&:to_i).inject(&:+)
    SettleValue.new(wage: project_wage, project_wage: project_wage, income: income, minutes: minutes, project_hours: project_hours)
  end
end
