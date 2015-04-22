class MonthlySalesReport < Connection
  attr_accessor :month, :total_sales, :stream

  def initialize(database_name, month)
    super(database_name)
    @month = month
    @total_sales = self.determine_total_sales
  end

  def determine_total_sales
    results = self.exec("SELECT sum(amount) + sum(gst) AS total FROM transactions WHERE date_trunc('month', timestamp) = to_date('#{@month}','MM-YYYY')")
    results.each { |row| return row['total'] }
  end
end
