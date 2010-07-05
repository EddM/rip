String.class_eval do
  def pad_binary_string(len, char = "0")
    size < len ? "#{char * (len-size)}#{self}" : self
  end
end