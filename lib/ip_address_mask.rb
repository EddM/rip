class IPAddressMask
  attr_reader :mask, :segments

  def initialize(mask = "0.0.0.0/0")
    cidr = mask.split(/\//)[0..1]
    if cidr.size < 1
      @mask = 0
      @segments = [0, 0, 0, 0]
    else
      addr = cidr[0].split(/\./).map { |s| (s.to_i > 0 ? (s.to_i > 255 ? 255 : s.to_i) : 0) }
      @segments = addr[0..3] + ([0] * (4-addr[0..3].size))
      if cidr.size > 1
        @mask = (cidr[1].to_i > 0 ? (cidr[1].to_i > 32 ? 32 : cidr[1].to_i) : 0)
      else
        @mask = 0
      end
    end
  end
  
  def to_a
    @segments + [@mask]
  end
  
  def to_s
    "#{@segments.join(".")}/#{@mask}"
  end
  
  def to_bin
    @segments.collect { |s| s.to_binary_string }.join
  end
  
  def matches?(addr)
    mask == 0 || to_bin[0..(mask-1)] == addr.to_bin[0..(mask-1)]
  end
  
end