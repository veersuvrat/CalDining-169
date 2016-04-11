class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items/1
  # GET /items/1.json
  def show
    @meal = params[:meal]
    @location = params[:location]
    @menu_id = Menu.where(:meal => @meal, :location => @location).first.id
    item = Item.where(:id => params[:id]).first
    @other_locations = item.menus.where(:meal => @meal).reject {|menu|  menu.location == @location}
  end

  def upload_picture
    uploaded_io = params[:picture]
    extension = File.extname(uploaded_io.original_filename)
    File.open(Rails.root.join('app', 'user_uploads', 'niceness'+extension), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    redirect_to menus_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name)
    end
end
