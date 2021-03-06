class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pins = Pin.all.order("created_at DESC").page(params[:page]).per(20)
  end

  def show
  end

  def edit
    return not_authorized unless current_user == @pin.user
  end

  def destroy
    return not_authorized unless current_user == @pin.user
    @pin.destroy
    redirect_to root_path, notice: "Pin destroyed"
  end

  def update
    return not_authorized unless current_user == @pin.user
    if @pin.update(pin_params)
      redirect_to @pin, notice: "Pin updated"
    else
      render 'edit'
    end
  end

  def upvote
    @pin.upvote_by(current_user)
    redirect_to :back
  end

  def create
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to @pin, notice: "Sucessfully created pin"
    else
      render 'new'
    end

  end

  def new
    @pin = current_user.pins.build
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end

  def not_authorized
    redirect_to pins_path, notice: "Denied"
  end
end
