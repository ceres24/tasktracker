module ApplicationHelper

  # Prints out '6 hours ago, Yesterday, 2 weeks ago, 5 months ago, 1 year ago'
  def recent_activity(past_time)
    return '' unless past_time.kind_of?(Time)
    time_ago_in_words(past_time)
    seconds_ago = (Time.now - past_time)
    color = if seconds_ago < 60.minute then "#6DD1EC"
    elsif seconds_ago < 1.day then "#ADDD1E"
    elsif seconds_ago < 2.day then "#CEDC34"
    elsif seconds_ago < 1.week then "#CEDC34"
    elsif seconds_ago < 1.month then "#DCAA24"
    elsif seconds_ago < 1.year then "#C2692A"
    else "#AA2D2F"
    end
    "<span style='color:#{color};font-weight:bold;font-variant:small-caps;'>#{time_ago_in_words(past_time)} ago</span>".html_safe
  end

  def simple_date(past_date)
    return '' if past_date.blank?
    if past_date == Date.today
      'Today'
    elsif past_date == Date.today - 1.day
      'Yesterday'
    elsif past_date == Date.today + 1.day
      'Tomorrow'
    elsif past_date.year == Date.today.year
      past_date.strftime("%b %d")
    else
      past_date.strftime("%b %d, %Y")
    end
  end

  def simple_weekday(date)
    return '' unless date.kind_of?(Time) or date.kind_of?(Date)
    date.strftime("%a")
  end

  def simple_date_and_weekday(date)
    [simple_date(date), simple_weekday(date)].select{|i| not i.blank?}.join(', ')
  end

  def simple_time(past_time)
    return '' if past_time.blank?
    if past_time.to_date == Date.today
      past_time.strftime("at %I:%M %p")
    elsif past_time.year == Date.today.year
      past_time.strftime("on %b %d at %I:%M %p")
    else
      past_time.strftime("on %b %d, %Y at %I:%M %p")
    end
  end

  def display_status(status)
    result = '<table class="status-table" style="background-color:transparent"><tr>'
    case status when 'planned'
      result << "<td><div class=\"status_marked planned\" title=\"Planned\">P</div></td><td><div class=\"status_unmarked\" title=\"Ongoing\">O</div></td><td><div class=\"status_unmarked\" title=\"Completed\">C</div></td>"
    when 'ongoing'
      result << "<td><div class=\"status_marked planned\" title=\"Planned\">P</div></td><td><div class=\"status_marked ongoing\" title=\"Ongoing\">O</div></td><td><div class=\"status_unmarked\" title=\"Completed\">C</div></td>"
    when 'completed'
      result << "<td><div class=\"status_marked planned\" title=\"Planned\">P</div></td><td><div class=\"status_marked ongoing\" title=\"Ongoing\">O</div></td><td><div class=\"status_marked completed\" title=\"Completed\">C</div></td>"
    end
    result << '</tr></table>'
    result.html_safe
  end

  def draw_chart(chart_api, chart_type, values, chart_element_id, chart_params, categories)
    if chart_api == 'highcharts'
      highcharts_chart(chart_type, values, chart_element_id, chart_params, categories)
    end
  end

  def simple_check(checked)
    image_tag("gentleface/16/#{checked ? 'checkbox_checked' : 'checkbox_unchecked'}.png", alt: '', style: 'vertical-align:text-bottom')
  end

  def highcharts_chart(chart_type, values, chart_element_id, chart_params, categories)
    @values = values
    @chart_element_id = chart_element_id
    @chart_type = chart_type
    @chart_params = chart_params
    @categories = categories
    render partial: 'charts/highcharts_chart'
  end

  def target_link_as_blank(text)
    text.gsub(/<a(.*?)>/, '<a\1 target="_blank">').html_safe
  end

  # def simple_format_links_target_blank(text)
  #   target_link_as_blank(simple_format(text))
  # end

  def simple_markdown(text)
    markdown = Redcarpet::Markdown.new( Redcarpet::Render::HTML, no_intra_emphasis: true, fenced_code_blocks: true, autolink: true, strikethrough: true, superscript: true )
    target_link_as_blank(markdown.render(text))
  end
end
