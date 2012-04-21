class Transaction < ActiveRecord::Base
  attr_accessible :amount, :date, :sector, :supplier_name, :address

  scope :sector, lambda { |sector| sector ? where("sector = ?", sector) : scoped }
  scope :for_user, lambda { |user| where("user_id = ?", user) }

  def self.sectors
    find(:all, :select => "distinct sector").map(&:sector)
  end

  def self.sum_for_month(month_date)
    conds = ["YEAR(date) = YEAR(?) and MONTH(date) = MONTH(?)", month_date, month_date]

    sum(:amount, :conditions => conds)
  end

  def self.avg_per_month
    entries = sum(:amount, :group => "YEAR(date), MONTH(date)")
    return 0 if entries.empty?
    entries.values.sum / entries.size
  end
end
