Fixnum.class_eval do
  def to_binary_string(word_len = 8, char = '0')
    to_s(2).pad_binary_string(word_len, char)
  end
end