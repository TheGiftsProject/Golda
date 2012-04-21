class TransactionsController < ApplicationController
  def index
    @name = params[:id]
    wanted_sector = params.fetch(:sector) { nil }
    @txns = user_txns
    @sectors = Transaction.sectors_for_user(@name)

    @this_month = Transaction.sum_for_month(@name, wanted_sector, Time.now)
    @prev_month = Transaction.sum_for_month(@name, wanted_sector, Time.now - 1.month)
    @avg_month = Transaction.avg_per_month(@name, wanted_sector)
  end

  private
  def user_txns
    Transaction.for_user(@name).sector(params.fetch(:sector) { nil })
  end
end
