require './utility.rb'
require './second_page.rb'
require './vigenere.rb'
require './password.rb'

def the(s) s[0..3].upcase end
def check_sum(s)
  sum = s.bytes.inject(0){|acc,c| acc += c}
  sum % 26 == 0
end

def sort_by_frequency(text)
  text.downcase.split('').each_with_object({}) { |char, result|
    result[char] = (result[char] || 0) + 1
  }.sort { |a, b| a[1] <=> b[1] }.reverse.map(&:first)
end

def frequiently_letters
  %w[e t a o i n s h r d l c u m w f g y p b v k j x q z]
end

def solve
  alphabet_range = ('A' .. 'Z')
  num = 0
  alphabet_range.each do |a|
    alphabet_range.each do |b|
      alphabet_range.each do |c|
        alphabet_range.each do |d|
          password = "#{a}#{b}#{c}#{d}"
          plain_text = decode_vigenere($text, password)
          # hint given by oracle
          if check_sum(plain_text[1 .. -1]) && plain_text.include?('box')
            frequiency = sort_by_frequency(plain_text)
            if frequiency[0..4].include?('e')
              num += 1
              puts "plain text : #{plain_text}"
              puts "[#{num}] #{password}  : #{plain_text[9 * 2, 9]}"
              puts frequiently_letters.join('.')
              puts frequiency.join('.')
            end
          end
        end
      end
    end
  end
end
