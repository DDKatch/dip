module HomeworksHelper
  class ChunkyPNG::Image

    def *(image)
      result_image = self.clone
      result_image.px_map! do |px, i, j|
        image_pix_v = image.color_value(:rgb, image[j, i]).reverse
        result_image.change_color(px) do |ch|
          res_px = ch * yield(image_pix_v.pop)
          res_px > 255 ? 255 : res_px.abs
        end
      end
      return result_image
    end

    def +(image)
      result_image = self.clone
      result_image.px_map! do |px, i, j|
        image_pix_v = image.color_value(:rgb, image[j, i]).reverse
        result_image.change_color(px) do |ch|
          res_px = ch + yield(image_pix_v.pop)
          res_px > 255 ? 255 : res_px.abs
        end
      end
      return result_image
    end

    def and(image)
      result_image = self.clone
      result_image.px_map!{|px, i, j| px & yield(image[j, i])}
      return result_image
    end

    def or(image)
      result_image = self.clone
      result_image.px_map!{|px, i, j| px | yield(image[j, i])}
      return result_image
    end

    def not(image)
      result_image = self.clone
      result_image.px_map!{|px, i, j| result_image.change_color(px){|ch| 255 - yield(ch)}}
      return result_image
    end

    def xor(image)
      result_image = self.clone
      result_image.px_map! do |px, i, j|
        image_pix_v = image.color_value(:rgb, image[j, i]).reverse
        result_image.change_color(px){|ch| ch ^ yield(image_pix_v.pop)}
      end
      return result_image
    end

    def self.new_const(image)
      result_image = image.clone
      random_value = Random.rand(255)
      result_image.px_map! {|px| image.change_color(px){|_|random_value}}
      return result_image
    end
  end
end
