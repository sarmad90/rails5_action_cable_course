module ApplicationHelper
  def flash_alert_type(name)
    case name.to_s
      when "notice"
        "success"
      when "warning"
        "warning"
      when "info"
        "info"
      else
        "danger"
    end
  end
end
