require 'fileutils'

class UploadController < ApplicationController
  # def new
  #   respond_to do |format|
  #     msg = {:status => 200, :filename => params[:filename]}
  #     format.json { render :json => msg } # don't do msg.to_json
  #   end
  # end

  def create
    puts "params #{params}"
    extension = File.extname(params[:filename])
    filename = "#{SecureRandom.uuid}#{extension}"
    dirname = File::join(Rails.public_path, 'images', 'upload')
    path = File::join(Rails.public_path, 'images', 'upload', filename)

    puts "filename: #{path}"
    puts "filename: https://taustore.herokuapp.com/images/upload/#{filename}"

    unless File.directory?(dirname)
      puts "uploading: create uploading directory #{dirname}"
      FileUtils.mkdir_p(dirname)
    end

    File.open(path, 'wb') { |f| f.write(params[:file].read) }

    respond_to do |format|
      msg = {:status => 200, :filename => "https://taustore.herokuapp.com/images/upload/#{filename}"}
      format.json { render :json => msg } # don't do msg.to_json
    end
  end
end