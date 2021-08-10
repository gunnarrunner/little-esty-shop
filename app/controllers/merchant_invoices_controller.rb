class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])

    # @discounted_revenue = if @invoice.quantity >= @merchant.quantity_threshold
    #   # calculation for discount
    # else
    #   "Threshold not meant"
    # end
  end
end
