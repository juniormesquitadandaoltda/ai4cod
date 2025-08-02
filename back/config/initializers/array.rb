class Array
  def to_enum
    reduce({}) { |h, p| h.merge!(p => p.to_s) }
  end
end
