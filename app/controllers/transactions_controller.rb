class TransactionsController < ApplicationController
  def index
    @name = params[:id]
    wanted_sector = params.fetch(:sector) { nil }
    @sectors = Transaction.sectors_for_user(@name)
    if wanted_sector
      @txns = Transaction.for_user_and_sector(@name, wanted_sector)
    else
      @txns = Transaction.for_user(@name)
    end
  end
end
