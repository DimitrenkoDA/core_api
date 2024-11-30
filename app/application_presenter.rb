class ApplicationPresenter
  protected def timestamp(timestamp, time_zone: nil)
    return if timestamp.blank?

    if time_zone.nil?
      timestamp.utc.iso8601
    else
      timestamp.in_time_zone(time_zone).iso8601
    end
  end

  protected def money(value)
    return if value.blank?

    {
      value: value.to_f,
      currency: value.currency.to_s
    }
  end
end
