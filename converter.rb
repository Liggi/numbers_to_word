class Numbers
  NUMBERS = {
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "fourty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
  }

  MAGNITUDES = {
    7 => "quintillion",
    6 => "quadrillion",
    5 => "trillion",
    4 => "billion",
    3 => "million",
    2 => "thousand",
    1 => "hundred"
  }

  def self.get_word_for_number(num)
    NUMBERS[num]
  end

  def self.get_magnitude(magnitude)
    MAGNITUDES[magnitude]
  end
end

class Converter
  def self.convert_number_to_word(num)
    grouped_num = split_to_magnitudes(num)
    last_group_no_hundreds = grouped_num[grouped_num.length - 1][0] == "0"

    magnitude = grouped_num.length

    str = ""
    grouped_num.each do |group|
      str += map_to_words(group, magnitude, last_group_no_hundreds)
      magnitude -= 1
    end

    if(last_group_no_hundreds)
      str = str.reverse.sub(',', 'dna ').reverse
    end

    str
  end

  def self.split_to_magnitudes(num)
    return_arr = []
    num_arr = num.to_s.split("")

    while (num_arr.length > 0)
      return_arr.unshift(num_arr.pop(3))
    end

    return_arr.map! { |group| group.length > 2 ? [group[0], group[1] + group[2]] : group }
    return_arr.map! { |group| group.any? { |n| n.length > 1 } ? group : [group.join("")] }
  end

  def self.map_to_words(num_group, magnitude, last_group_no_hundreds)
    return_str = ""
    has_hundred = num_group.length > 1 && num_group[0] != "0"
    has_zeros = num_group.include?("00") || num_group[0] == "0"

    num_group.each do |the_number|
      if(the_number != "0" && the_number != "00")
        return_str += process_above_ten(the_number)
        return_str += " hundred" if has_hundred
        return_str += " and " if has_hundred && !has_zeros
        has_hundred = false
      end
    end

    if magnitude > 1 and return_str != ""
      return_str += " " + Numbers.get_magnitude(magnitude)
      return_str += ", "
    end

    return_str
  end

  def self.process_above_ten(num_str)
    num = num_str.to_i
    remainder = num % 10

    if(remainder == 0)
      Numbers.get_word_for_number(num)
    else
      if num <= 20
        Numbers.get_word_for_number(num_str.to_i)
      else
        Numbers.get_word_for_number(num_str.split("")[0].to_i * 10) + "-" + Numbers.get_word_for_number(remainder)
      end
    end
  end
end

(1..1000000).each do |i|
  puts Converter.convert_number_to_word(i)
end
