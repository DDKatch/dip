class HomeworksController < ApplicationController
  def index
    case params[:operation]
    when "and"
      init_variables(:and)
    when "or"
      init_variables(:or)
    when "not"
      init_variables(:not)
    else
      init_variables(:filter)
    end
  end

  def init_variables(operation)
    @image_name = []
    @image_name << 'house.png'

    @image_path = Rails.root.join('app', 'assets', 'images', @image_name[0])
    image = ChunkyPNG::Image.from_file(@image_path)

    @charts = []
    @charts << image.histogram(:bright)

    case operation
    when :and || :or || :not || :add_c || :mult_c || :slice
      @image_name << 'const.png'
      @image_path = Rails.root.join('app', 'assets', 'images', @image_name[1])
      (ChunkyPNG::Image.new_const(image)).save(@image_path)
    when :add_p || :mult_p
      @image_name << 'image.png'
    when :mask
      @image_name << 'mask.png'
      @image_path = Rails.root.join('app', 'assets', 'images', @image_name[1])
      (ChunkyPNG::Image.new_mask(image)).save(@image_path)
    else
      @image_name << 'const.png'
      @image_path = Rails.root.join('app', 'assets', 'images', @image_name[1])
      (ChunkyPNG::Image.new_const(image)).save(@image_path)
    end

    const_or_img_or_msk = ChunkyPNG::Image.from_file(@image_path)
    @charts << const_or_img_or_msk.histogram(:bright)

    temp = image.method(operation).call(const_or_img_or_msk)
    @image_name << 'result.png'
    temp.save(Rails.root.join('app', 'assets', 'images', @image_name[2]))
    @charts << temp.histogram(:bright)
  end

end

