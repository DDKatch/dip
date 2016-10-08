class HomeworksController < ApplicationController
  def index
    init_variables

    symb = case params[:operation]
    when "and" then :and
    when "or" then :or
    when "xor" then :xor
    when "not" then :not
    when "+" then :-
    when "-" then :+
    when "*" then :*
    when "/" then :/
    else symb = :and
    end
    !symb.nil? && use_operation(symb)
  end

  def use_operation(operation)
    case operation
    when :slice then
    when :add_p || :mult_p then
      @images[1] = @images[4]
    when :mask then
      @images[1] = ChunkyPNG::Image.new_mask(@images[0])
    when :not then
    when :-
      @images[2] = @images[0].method(:+).call(@images[1]){|px| -1 * px}
    when :/
      @images[2] = @images[0].method(:*).call(@images[1]){|px| 1/px}
    else
      @images[1] = ChunkyPNG::Image.new_const(@images[0])
      @images[2] = @images[0].method(operation).call(@images[1]){|px| px}
    end
    upload_images
    init_variables
  end

  def upload_images
    @images.each_with_index do |img, ind|
      Cloudinary::Uploader.upload(img.to_data_url,
                                  :public_id => @image_name[ind].sub('.png', ''))
    end
  end

  def init_charts
    Array.new(3) {|ind| @images[ind].histogram(:bright)}
  end

  def init_images
    images = Array.new(5)
    @image_name.each_with_index do |name, i|
      image_url = Cloudinary::Utils.cloudinary_url(name)
      images[i] = ChunkyPNG::Image.from_blob(open(image_url).read)
    end
    return images
  end

  def init_variables
    @image_name = %w{house.png const.png result.png mask.png other.png}
    @images = init_images
    @charts = init_charts
  end

  def show
    init_variables
  end
end

