String.class_eval do
  def pad_binary_string(word_len, char = "0")
    size < word_len ? "#{char * (word_len-size)}#{self}" : self
  end
end