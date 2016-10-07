module HomeworksHelper
  class ChunkyPNG::Image
    def add(img)
      result_image = self.clone
      result_image.px_map!{|px, i, j| px & img[j, i]}
      return result_image
    end

    def self.new_const(image)
      #binding.pry
      result_image = ChunkyPNG::Image.new(image.width, image.height)
      random_value = Random.rand(255)
      result_image.px_map! {|px| change_color(px){|_|random_value}}
      return result_image
    end
  end
end
