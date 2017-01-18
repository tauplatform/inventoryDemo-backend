require 'fileutils'

class UploadController < ApplicationController
  # def new
  #   respond_to do |format|
  #     msg = {:status => 200, :filename => params[:filename]}
  #     format.json { render :json => msg } # don't do msg.to_json
  #   end
  # end

  def create
    extension = File.extname(params[:file].original_filename)
    filename = "#{SecureRandom.uuid}#{extension}"
    dirname = File::join(Rails.public_path, 'images', 'upload')

    unless File.directory?(dirname)
      puts "uploading: create uploading directory #{dirname}"
      FileUtils.mkdir_p(dirname)
    end

    path = File::join(Rails.public_path, 'images', 'upload', filename)
    File.open(path, 'wb') { |f| f.write(params[:file].read) }
    #redirect_to :action => :new, :filename => "https://taustore.herokuapp.com/images/upload/#{filename}"
    puts "filename: #{path}"
    puts "filename: https://taustore.herokuapp.com/images/upload/#{filename}"
    respond_to do |format|
      msg = {:status => 200, :filename => "https://taustore.herokuapp.com/images/upload/#{filename}"}
      format.json { render :json => msg } # don't do msg.to_json
    end
  end
end