module ActiveSupport
  class TimeWithZone
    def to_api
      strftime('%Y-%m-%d %H:%M:%S %z')
    end
  end
end

class Date
  def to_api
    strftime('%Y-%m-%d')
  end
end
