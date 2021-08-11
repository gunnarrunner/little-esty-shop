class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @customer = Customer.find(@invoice.customer_id)
    @merchant = @invoice.unique_merchant
  end

  def update
    @invoice = Invoice.find(params[:id])
    @invoice.update!(invoice_params)

    redirect_to admin_invoice_path(@invoice)
  end

  private
  def invoice_params
    params.permit(:status, :customer_id)
  end
end
