module ErrorHandler
  extend ActiveSupport::Concern

  def errors
    @errors || []
  end

  def has_error?
    return false unless @errors
    @errors.size > 0
  end

  protected

  def rescue_errors(&block)
    begin
      yield
    rescue ErrorException => e
      @errors ||= []
      msgs = e.to_hash[:info][:error_messages] || []
      msgs = [msgs] if msgs.is_a?(String)
      msgs.each{ |m| @errors << m }
      false
    end
  end

  def add_error(message)
    @errors ||= []
    @errors << message
    false
  end
end
