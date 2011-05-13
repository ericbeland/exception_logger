module LoggedExceptionsHelper
  def pretty_exception_date(exception)
    if Date.today == exception.created_at.to_date
      if exception.created_at > Time.now - 4.hours
        "#{time_ago_in_words(exception.created_at).gsub(/about /,"~ ")} ago"
      else
        "Today, #{exception.created_at.strftime(Time::DATE_FORMATS[:exc_time])}"
      end
    else
      exception.created_at.strftime(Time::DATE_FORMATS[:exc_date])
    end
  end
  
  def filtered?
    [:query, :date_ranges_filter, :exception_names_filter, :controller_actions_filter].any? { |p| params[p] }
  end
  
  def listify(text)
    list_items = text.scan(/^\s*\* (.+)/).map {|match| content_tag(:li, match.first) }
    content_tag(:ul, list_items)
  end

  def page_title(text)
    title = ""
    unless controller.application_name.blank?
      title << "#{controller.application_name} :: "
    end
    title << text.to_s
    content_for(:title, title.to_s)
  end

  # Rescue textilize call if RedCloth is not available.
  def pretty_format(text)
    begin
     txt = textilize(text).html_safe
    rescue
     txt = simple_format(text).html_safe
    end
     # In Ruby 1.9.x, Encoding is defined, so we force our default encoding
     # to work around this Ruby 1.9 error:
     # Encoding::CompatibilityError in LoggedExceptions/show
     # "incompatible character encodings: ASCII-8BIT and UTF-8"
     defined?(Encoding) ? txt.encode(Encoding.default_internal.to_s, undef: :replace) : txt
  end
end
