class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    merchant.bulk_discounts << bulk_discount

    if bulk_discount.save
      redirect_to "/merchants/#{merchant.id}/bulk_discounts"
    else
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/new"
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end
  
  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])

    if bulk_discount.update(bulk_discount_params)
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"
    else
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end
  
  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end
  
private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end