Spec::Matchers.define :match_cidr_mask do |mask|
  match do |address|
    address.matches?(mask)
  end
end