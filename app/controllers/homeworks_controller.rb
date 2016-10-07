class HomeworksController < ApplicationController
  def index
    @can_render = false
    symb = case params[:operation]
    when "and" then :and
    when "or" then :or
    when "xor" then :xor
    when "not" then :not
    end
    init_variables(symb)
    @can_render = true
  end

  def init_variables(operation)
    @image_name = %w{house.png const.png result.png mask.png other.png}
    image_path = lambda{|name|Rails.root.join('app', 'assets', 'images', name)}

    images = []
    @image_name.each_with_index do |name, i|
      images << ChunkyPNG::Image.from_file(image_path.call(@image_name[i]))
    end

    images[1] = ChunkyPNG::Image.new_const(images[0])

    case operation
    when :slice then
    when :add_p || :mult_p then
      images[1] = images[4]
    when :mask then
      images[1] = ChunkyPNG::Image.new_mask(images[0])
    when :not then
    else
    end

    images[2] = images[0].method(operation).call(images[1])

    @charts = []
    3.times do |ind|
      @charts << images[ind].histogram(:bright)
    end

    images.each_with_index {|img, ind| img.save(image_path.call(@image_name[ind]))}
  end

end

