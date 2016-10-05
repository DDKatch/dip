module ImageProcessorsHelper
  class ChunkyPNG::Image

        end
      end


    end

    def path
      Rails.root.join('app', 'assets', 'images', 'house.png')
    def histogram(color_channel)
      color_count = Array.new(256) {|elem| elem = 0}

      self.each_px {|px| color_count[color_value(color_channel, px)] += 1}

      return Hash[(0...color_count.size).zip(color_count)]
    end
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
