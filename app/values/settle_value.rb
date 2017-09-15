class SettleValue < BaseValue
  attr_accessor :minutes, :wage, :project_wage, :income, :hours, :project_hours

  def hours
    @hours ||= hour_round(minutes.to_f / 60)
  end

  def wage
    @wage || project_wage
  end

  def income
    @income ||= wage ? hours * wage : nil
  end

  def project_hours
    @project_hours ||= project_wage ? hour_round(income.to_f / project_wage) : nil
  end

  private

  def hour_round(hours_value)
    v = hours_value.to_f - hours_value.to_i
    if v <= 0.25
      v = 0
    elsif v <= 0.75
      v = 0.5
    else
      v = 1
    end
    hours_value.to_i + v
  end
end
