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

    @this_month = Transaction.sum_for_month(@name, wanted_sector, Time.now)
    @prev_month = Transaction.sum_for_month(@name, wanted_sector, Time.now - 1.month)
    @avg_month = Transaction.avg_per_month(@name, wanted_sector)
  end
end
