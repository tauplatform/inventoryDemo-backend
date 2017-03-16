class InventoryItemsController < ApplicationController
  before_action :set_inventory_item, only: [:show, :edit, :update, :destroy]

  def initialize
    super
    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
        region: ENV['AWS_REGION']
    )
    @s3bucket = s3.bucket('inventory-demo')
  end

  def index
    # we implement limit and offset
    if params['offset'] && params['limit']
      @inventory_items = InventoryItem.all(:offset => params['offset'].to_i, :limit => params['limit'].to_i)
    else
      @inventory_items = InventoryItem.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @inventory_items }
      format.xml { render :xml => @inventory_items }
    end
  end

  def show
    @inventory_item = InventoryItem.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @inventory_item }
      format.xml { render :xml => @inventory_item }
    end
  end

  def new
    @inventory_item = InventoryItem.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @inventory_item }
      format.xml { render :xml => @inventory_item }
    end
  end

  def edit
    @inventory_item = InventoryItem.find(params[:id])
  end

  def uploadFileToS3(aFile)
    extension = File.extname(aFile.original_filename)
    key = "#{SecureRandom.uuid}#{extension}"
    File.open(Rails.root.join('public', 'uploads', key), 'wb') do |file|
      file.write(aFile.read)
      obj = @s3bucket.object(key)
      obj.upload_file(Rails.root.join('public', 'uploads', key), {:acl => 'public-read'})
      File.delete(Rails.root.join('public', 'uploads', key))
      return obj.public_url.gsub("https://", "http://")
    end
  end

  def create
    attrs = Hash.new
    attrs[:productName] = params[:inventory_item]['productName']
    attrs[:upc] = params[:inventory_item]['upc']
    attrs[:quantity] = params[:inventory_item]['quantity']
    attrs[:employeeId] = params[:inventory_item]['employeeId']
    if params[:inventory_item][:photoUri].class == ActionDispatch::Http::UploadedFile
      puts "params[:inventory_item][:photoUri] is ActionDispatch::Http::UploadedFile"
      attrs[:photoUri] = uploadFileToS3(params[:inventory_item][:photoUri])
    elsif params[:inventory_item]['photoUri'] != nil
      puts "params[:inventory_item][:photoUri] is not nil"
      attrs[:photoUri] = params[:inventory_item]['photoUri']
    end
    if params[:inventory_item][:signatureUri].class == ActionDispatch::Http::UploadedFile
      puts "params[:inventory_item][:signatureUri] is ActionDispatch::Http::UploadedFile"
      attrs[:signatureUri] = uploadFileToS3(params[:inventory_item][:signatureUri])
    elsif params[:inventory_item]['signatureUri'] != nil
      puts "params[:inventory_item][:signatureUri] is not nil"
      attrs[:signatureUri] = params[:inventory_item]['signatureUri']
    end
    @inventory_item = InventoryItem.new(attrs)
    respond_to do |format|
      if @inventory_item.save
        flash[:notice] = 'InventoryItem was successfully created.'
        format.html { redirect_to(@inventory_item) }
        format.xml { render :xml => @inventory_item, :status => :created, :location => @inventory_item }
        format.json { render :json => @inventory_item, :status => :created, :location => @inventory_item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @inventory_item.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @inventory_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @inventory_item = InventoryItem.find(params[:id])
    attrs = Hash.new
    attrs[:productName] = params[:inventory_item]['productName']
    attrs[:upc] = params[:inventory_item]['upc']
    attrs[:quantity] = params[:inventory_item]['quantity']
    attrs[:employeeId] = params[:inventory_item]['employeeId']
    if params[:inventory_item][:photoUri].class == ActionDispatch::Http::UploadedFile
      puts "params[:inventory_item][:photoUri] is ActionDispatch::Http::UploadedFile"
      attrs[:photoUri] = uploadFileToS3(params[:inventory_item][:photoUri])
    elsif params[:inventory_item]['photoUri'] != nil
      puts "params[:inventory_item][:photoUri] is not nil"
      attrs[:photoUri] = params[:inventory_item]['photoUri']
    end
    if params[:inventory_item][:signatureUri].class == ActionDispatch::Http::UploadedFile
      puts "params[:inventory_item][:signatureUri] is ActionDispatch::Http::UploadedFile"
      attrs[:signatureUri] = uploadFileToS3(params[:inventory_item][:signatureUri])
    elsif params[:inventory_item]['signatureUri'] != nil
      puts "params[:inventory_item][:signatureUri] is not nil"
      attrs[:signatureUri] = params[:inventory_item]['signatureUri']
    end
    respond_to do |format|
      if @inventory_item.update_attributes(attrs)
        flash[:notice] = 'InventoryItem was successfully updated.'
        format.html { redirect_to(@inventory_item) }
        format.xml { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @inventory_item.errors, :status => :unprocessable_entity }
        format.json { render :json => @inventory_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @inventory_item = InventoryItem.find(params[:id])
    @inventory_item.destroy

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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_inventory_item
    @inventory_item = InventoryItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def inventory_item_params
    params.require(:inventory_item).permit(:upc, :productName, :quantity, :employeeId, :photoUri, :signatureUri)
  end
end
