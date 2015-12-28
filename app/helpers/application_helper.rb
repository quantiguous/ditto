module ApplicationHelper

  def formatted_time(time)
    formatted_time = time.strftime('%v %r')
    return formatted_time
  end
end
