class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = find_item
    render json: item
  end

  def create
    user = find_user
    item = user.items.create(items_params)
    render json: item, status: :created
  end


  private
  
  def find_user
    User.find(params[:user_id])
  end

  def find_item
    Item.find(params[:id])
  end

  def render_not_found_response(item)
    render json: { error: "#{item} Not Found" }, status: :not_found
  end

  def items_params
    params.permit(:name, :description, :price)   
  end

end
