module ApplicationHelper
  def field_error(model, field)
    return unless model.errors[field].any?

    tag.div model.errors.full_messages_for(field).join(", "), class: "error-message"
  end

  def format_date_time(date_time)
    date_time.strftime("%Y/%m/%d - %H:%M")
  end
end
