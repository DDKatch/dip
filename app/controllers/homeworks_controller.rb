class HomeworksController < ApplicationController
  def index
    init_variables
  end

  def init_variables
    @image_name = []
    @image_name << 'house.png'

    @image_path = Rails.root.join('app', 'assets', 'images', @image_name[0])
    image = ChunkyPNG::Image.from_file(@image_path)

    @charts = []
    @charts << image.histogram(:bright)


    temp = image.dissection(:e, 100, 200)
    @image_name << temp.to_data_url
    @charts << temp.histogram(:bright)

    temp = image.filter(:max)
    @image_name << temp.to_data_url
    @charts << temp.histogram(:bright)
  end
end

