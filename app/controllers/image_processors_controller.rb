class ImageProcessorsController < ApplicationController

  def index
    init_variables
  end

  def create
  end

  def init_variables
		@image_name = 'house.png'
    @image_path = Rails.root.join('app', 'assets', 'images', @image_name)

    image1 = MyImage.from_file(@image_path)

    # result = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
    # height.times do |j|
    #   width.times do |i|
    #     result[i,j] = img[i,j]#ChunkyPNG::Color.rgba(i,j,1+i*j, 128)
    #   end
    # end
    # result.save('result.png', interlace: true)

		#image2 = MiniMagick::Image.open(@img_path)
  	#im_details = image2.details["Histogram"]
    #im_details.nil? ? p('NIL') : p(im_details)

    r = image1.histogram(:red)
    g = image1.histogram(:green)
    b = image1.histogram(:blue)
    br = image1.histogram(:bright)

    #binding.pry

    temp = []
    (0...256).each {|i| temp << (r[i] + g[i] + b[i])/3}

    rgb = Hash[(0...256).zip(temp)]

    @charts = [r,g,b,br,rgb]
  end

end
