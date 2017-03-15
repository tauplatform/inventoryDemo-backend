require 'aws-sdk'

class InventoryItemsController < ApplicationController

  def initialize
    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
        region: 'us-west-2'
    )
    @s3bucket = s3.bucket('inventory-demo')
  end

  def index
    # we implement limit and offset
    if params['offset'] && params['limit']
      @items = InventoryItem.all(:offset => params['offset'].to_i, :limit => params['limit'].to_i)
    else
      @items = InventoryItem.all

      puts "items #{@items}"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
      format.xml { render :xml => @items }
    end
  end

  def show
    @item = InventoryItem.find(params[:id])

    puts "show item #{@item}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item }
      format.xml { render :xml => @item }
    end
  end

  def new
    @item = InventoryItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item }
      format.xml { render :xml => @item }
    end
  end

  def edit
    @item = InventoryItem.find(params[:id])
  end

  def create
    uploaded_io = params[:inventory_item][:photoUri]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
      extension = File.extname(uploaded_io.original_filenam)
      key = "#{SecureRandom.uuid}#{extension}"
      obj = @s3bucket.object(key)
      obj.upload_file(Rails.root.join('public', 'uploads', uploaded_io.original_filename), {:acl => 'public-read'})
      params[:inventory_item][:photoUri] = object.public_url.gsub("https://", "http://")
    end

    uploaded_io = params[:inventory_item][:signatureUri]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
      extension = File.extname(uploaded_io.original_filenam)
      key = "#{SecureRandom.uuid}#{extension}"
      obj = @s3bucket.object(key)
      obj.upload_file(Rails.root.join('public', 'uploads', uploaded_io.original_filename))
      params[:inventory_item][:signatureUri] = obj.public_url
    end
    @item = InventoryItem.new(params[:inventory_item])
    respond_to do |format|
      if @item.save
        flash[:notice] = 'InventoryItem was successfully created.'
        format.html { redirect_to(@item) }
        format.xml { render :xml => @item, :status => :created, :location => @item }
        format.json { render :json => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @item = InventoryItem.find(params[:id])

    uploaded_io = params[:inventory_item][:photoUri]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
      extension = File.extname(uploaded_io.original_filenam)
      key = "#{SecureRandom.uuid}#{extension}"
      obj = @s3bucket.object(key)
      obj.upload_file(Rails.root.join('public', 'uploads', uploaded_io.original_filename), {:acl => 'public-read'})
      params[:inventory_item][:photoUri] = object.public_url.gsub("https://", "http://")
    end

    uploaded_io = params[:inventory_item][:signatureUri]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
      extension = File.extname(uploaded_io.original_filenam)
      key = "#{SecureRandom.uuid}#{extension}"
      obj = @s3bucket.object(key)
      obj.upload_file(Rails.root.join('public', 'uploads', uploaded_io.original_filename))
      params[:inventory_item][:signatureUri] = obj.public_url
    end


    respond_to do |format|
      if @item.update_attributes(params[:inventory_item])
        flash[:notice] = 'InventoryItem was successfully updated.'
        format.html { redirect_to(@item) }
        format.xml { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @item.errors, :status => :unprocessable_entity }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = InventoryItem.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(inventory_items_url) }
      format.xml { head :ok }
      format.json { head :ok }
    end
  end

  def destroy_all
    InventoryItem.destroy_all
    redirect_to(reports_url)
  end
end
