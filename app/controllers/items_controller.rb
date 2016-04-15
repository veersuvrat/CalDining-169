class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:upload_picture]

  # GET /items/1
  # GET /items/1.json
  def show
    @meal = params[:meal]
    @location = params[:location]
    @menu_id = Menu.where(:meal => @meal, :location => @location).first.id
    @item = Item.where(:id => params[:id]).first
    @images = @item.images.where(state: 1)
    @other_locations = @item.menus.where(:meal => @meal).reject {|menu|  menu.location == @location}
  end

  def upload_picture
    item = Item.where(:id => params[:id]).first
    Image.new(:filename => params[:filename], :state => 0, :item => item, :user => current_user).save
    redirect_to :back
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
