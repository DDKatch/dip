class HomeworksController < ApplicationController
  def index
    case params[:operation]
    when 'and'
      init_variables(:and)
    when 'or'
      init_variables(:or)
    when 'not'
      init_variables(:not)
    when 'xor'
      init_variables(:xor)
    else
      init_variables(:filter)
    end
  end

  def init_variables(operation)
    @image_name = %w{house.png const.png result.png}

    image_path = lambda{|name|Rails.root.join('app', 'assets', 'images', name)}
    image = ChunkyPNG::Image.from_file(image_path.call(@image_name[0]))

    @charts = []
    @charts << image.histogram(:bright)

    case operation
    when :and || :or || :xor ||:add_c || :mult_c || :slice
      @image_name[1] = 'const.png'
      (ChunkyPNG::Image.new_const(image)).save(image_path.call(@image_name[1]))
    when :add_p || :mult_p
      @image_name[1] = 'other_image.png'
    when :mask
      @image_name[1] = 'mask.png'
      (ChunkyPNG::Image.new_mask(image)).save(image_path.call(@image_name[1]))
    when :not
      @image_name[1] = 'house.png'
    end

    const_or_img_or_msk = ChunkyPNG::Image.from_file(image_path.call(@image_name[1]))
    @charts << const_or_img_or_msk.histogram(:bright)

    result = image.method(operation).call(const_or_img_or_msk)

    result.save(image_path.call(@image_name[2]))
    @charts << result.histogram(:bright)
  end

end

