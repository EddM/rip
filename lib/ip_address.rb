class IPAddress
  attr_reader :segments
  
  def initialize(address = "0.0.0.0")
    segs = address.split(/\./)[0..3]
    @segments = segs.map { |s| (s.to_i > 0 ? (s.to_i > 255 ? 255 : s.to_i) : 0) } + ([0] * (4 - segs.size))
  end
  
  def address
    @segments.join(".")
  end
  
  def to_a
    @segments.collect { |s| s.to_s(2).pad_binary_string(8) }
  end
  
  def to_s
    @segments.join(".")
  end
  
  def to_bin
    to_a.join
  end
  
  def matches?(mask)
    if mask.is_a?(IPAddressMask)
      mask.matches?(self)
    else
      IPAddressMask.new(mask).matches?(self)
    end
  end
  
end