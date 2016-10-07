module ImageProcessorsHelper
  class ChunkyPNG::Image


    def dissection(type, min = 0, max = 255)
      result_image = self.clone

      case type
      when :e then
        f_min, f_max = min, max
        result_image.px_map! do |px|
          color_value(:bright, px) <= f_min ? px = ChunkyPNG::Color.rgb(0,0,0) :
            f_max <= color_value(:bright, px) ? ChunkyPNG::Color.rgb(255,255,255) :
              px
        end
      when :d then
        g_min, g_max = min, max
        result_image.px_map! do |px|
          change_color(px){|i| i * (g_max - g_min) / 256 + g_min}
        end
      end

      return result_image
    end



    def change_color(px)
      ChunkyPNG::Color.rgb(
        *(ChunkyPNG::Color.to_truecolor_bytes(px)).map! {|i| yield(i)})
    end

    def histogram(color_channel)
      color_count = Array.new(256) {|elem| elem = 0}

      self.each_px {|px| color_count[color_value(color_channel, px)] += 1}

      return Hash[(0...color_count.size).zip(color_count)]
    end

    def filter(name)
      res_img = self.clone
      case name
      when :min then
        res_img.convolution(res_img.padding, [1, 1, 1,
                                              1, 1, 1,
                                              1, 1, 1], :min)
      when :max then
        res_img.convolution(res_img.padding, [1, 1, 1,
                                              1, 1, 1,
                                              1, 1, 1], :max)
      when :min_max then
        filter(:min)
        filter(:max)
      when :stamping then
        res_img.convolution(res_img.padding, [0, 1, 0,
                                              1, 0, -1,
                                              0, -1, 0], :reduce){:+}
      when :lapl_2 then
        res_img.convolution(res_img.padding, [1, 1, 1,
                                              1, -8, 1,
                                              1, 1, 1], :reduce){:+}
      end
      return res_img
    end

    def convolution(buf_img, operator, array_func)
      self.px_map! do |_, i, j|
        i += 1
        j += 1
        h = operator
        core = [change_color(buf_img[j-1, i-1]){|px| px* h[0]},
                change_color(buf_img[j, i-1]){|px| px * h[1]},
                change_color(buf_img[j+1, i-1]){|px| px * h[2]},
                change_color(buf_img[j-1, i  ]){|px| px * h[3]},
                change_color(buf_img[j, i  ]){|px| px * h[4]},
                change_color(buf_img[j+1, i  ]){|px| px * h[5]},
                change_color(buf_img[j-1, i+1]){|px| px * h[6]},
                change_color(buf_img[j, i+1]){|px| px * h[7]},
                change_color(buf_img[j+1, i+1]){|px| px * h[8]}]
        #   binding.pry
        block_given? ? new_px = (core.method(array_func).call(yield)).abs : new_px = core.send(array_func)
        new_px.class == Fixnum ? new_px : new_px.unique!
      end
      return self
    end

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
        (ChunkyPNG::Color.method(:r).call(pixel) * 0.3 +
          ChunkyPNG::Color.method(:g).call(pixel) * 0.59 +
          ChunkyPNG::Color.method(:b).call(pixel) * 0.11).to_i
      when :rgb
        [ChunkyPNG::Color.method(:r).call(pixel),
        ChunkyPNG::Color.method(:g).call(pixel),
        ChunkyPNG::Color.method(:b).call(pixel)]
      end
    end

    def px_map!
      block_given? ? self.each_px {|px, i, j| self[j, i] = yield(self[j, i], i, j)} :
        p("NO BLOCK GIVEN")
      return self
    end

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
