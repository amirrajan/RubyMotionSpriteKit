class StringWrapper
  def self.wrap wrap_length, text
    results = []

    if text.empty?
      results << ''
      return results
    end

    letter_array = text.split('')
    last_space = false
    current_length = 0

    letter_array.each_with_index do |letter, index|
      letter =~ /\s/ && last_space = index
      if letter == "\n"
        current_length = 0
      elsif current_length == wrap_length && last_space
        letter_array[last_space] = "\n"
        current_length = index - last_space
        last_space = false
      elsif current_length == @wrap_length
        letter_array.insert(index, "\n")
        current_length = 0
      else
        current_length += 1
      end
    end

    letter_array.last == "\n" && letter_array.delete_at(-1)

    letter_array.inject(:+).split("\n")
  end
end
