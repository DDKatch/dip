module ImageProcessorsHelper
  class ChunkyPNG::Image

    def histogram(color_channel, scale_divider = 1)
      image_h = self.height
      image_w = self.width
      color_count = Array.new(256) {|el| el = 0}

      image_h.times do |i|
        image_w.times do |j|
          color_count[color_value(color_channel, self[j, i])] += 1
        end
      end

      div_col_count = divide_scale(color_count, scale_divider)
      return Hash[(0...div_col_count.size).zip(div_col_count)]

      #binding.pry
    end

    def path
      Rails.root.join('app', 'assets', 'images', 'house.png')
    end

    def divide_scale(array, divider)
      scaled_array = []
      array.each_slice(divider) do |i|
        scaled_array << i.reduce(:+) / divider
      end
      return scaled_array
    end

    def color_value(color_channel, pixel)
      case color_channel
      when :red
        ChunkyPNG::Color.method(:r).call(pixel)
      when :green
        ChunkyPNG::Color.method(:g).call(pixel)
      when :blue
        ChunkyPNG::Color.method(:b).call(pixel)
      when :bright
        ChunkyPNG::Color.method(:r).call(pixel) * 0.3 +
          ChunkyPNG::Color.method(:g).call(pixel) * 0.59 +
          ChunkyPNG::Color.method(:b).call(pixel) * 0.11
      #don't work correctly
      when :rgb
        [ChunkyPNG::Color.method(:r).call(pixel),
        ChunkyPNG::Color.method(:g).call(pixel),
        ChunkyPNG::Color.method(:b).call(pixel)].max
      end
    end

    def filter(name)
      self.clone
    end

    private :color_value, :divide_scale

  end
end
