class TransactionsController < ApplicationController
  def index
    @name = params[:id]
    @sectors = Transaction.sectors_for_user(@name)
    @txns = Transaction.for_user(@name)
  end
end
