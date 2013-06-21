module Vigenere
  ASCII_LARGE_A =  65
  ASCII_LARGE_Z =  90
  ASCII_SMALL_A =  97
  ASCII_SMALL_Z = 122

  def self.upper_range
    (ASCII_LARGE_A .. ASCII_LARGE_Z)
  end

  def self.lower_range
    (ASCII_SMALL_A .. ASCII_SMALL_Z)
  end

  def self.encode_byte(num, key)
    result = num
    [upper_range, lower_range].each do |range|
      next unless range.include?(num)
      result += key
      result -= range.size if result > range.last
    end
    result
  end

  def self.decode_byte(num, key)
    result = num
    [upper_range, lower_range].each do |range|
      next unless range.include?(num)
      result -= key
      result += range.size if result < range.first
    end
    result
  end

  def self.encode(text, password)
    convert(:encode, text, password)
  end

  def self.decode(text, password)
    convert(:decode, text, password)
  end

  def self.convert(method_type, text, password)
    keys = password.upcase.unpack('C*').map { |c| c - 'A'.unpack('C').first }

    encoded_bytes = []
    text.bytes.each_with_index do |byte, idx|
      key = keys[idx % keys.size]
      encoded_bytes.push Vigenere.send("#{method_type}_byte".to_sym, byte, key)
    end

    encoded_bytes.flatten.pack('C*')
  end
end

def encode_vigenere(text, password)
  Vigenere.encode(text, password)
end

def decode_vigenere(text, password)
  Vigenere.decode(text, password)
end
