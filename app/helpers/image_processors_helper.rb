module ImageProcessorsHelper
  class ChunkyPNG::Image

        end
      end


    def change_color(px)
      ChunkyPNG::Color.rgb(
        *(ChunkyPNG::Color.to_truecolor_bytes(px)).map! {|i| yield(i)})
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
    # how it works
    # X - existing pixels
    # * - empty pixels
    #  _____
    # |*****|
    # |*XXX*|
    # |*****|
    #  _____
    def padding
      buf_img = ChunkyPNG::Image.new(self.width+2, self.height+2)
      self.each_px {|px, i, j| buf_img[j+1, i+1] = px}

      buf_img.replace_row!(0, buf_img.row(1))
      buf_img.replace_row!(buf_img.height-1, buf_img.row(buf_img.height-2))
      buf_img.replace_column!(0, buf_img.column(1))
      buf_img.replace_column!(buf_img.width-1, buf_img.column(buf_img.width-2))
      return buf_img
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
    def px_map!
      block_given? ? self.each_px {|px, i, j| self[j, i] = yield(self[j, i], i, j)} :
        p("NO BLOCK GIVEN")
      return self
    end

    private :color_value, :divide_scale

    def each_px(start_h = 0, start_w = 0, finish_h = self.height, finish_w = self.width)
      (start_h...finish_h).each do |i|
        (start_w...finish_w).each do |j|
          block_given? ? yield(self[j, i], i, j) : p("NO BLOCK GIVEN")
        end
      end
      return self
    end
  end
end
