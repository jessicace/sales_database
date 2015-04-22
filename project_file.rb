require 'rubygems' # Required to use gems.
require 'pg'
require './connection.rb'
require './sales_report.rb'

#$sales_connection = Connection.new('sales')
$monthly_sales_report = MonthlySalesReport.new('sales', '01-2015')
puts $monthly_sales_report
puts $monthly_sales_report.total_sales

def connection(query)
  $sales_connection.stream.exec(query) do |result|
    result.each do |row|
      row.each_pair do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end
end

#def top_5_transactions(connection, query)
#  connection.exec("SELECT sum(amount) + sum(gst) AS total_incl_gst FROM transactions #{where_clause}") do |result|
#    result.each do |row|
#      row.each_pair do |_, value|
#        "#{value}"
#      end
#    end
#  end
#end

month = '01-2015'
where_clause = "WHERE date_trunc('month', timestamp) = to_date('#{month}','MM-YYYY')"
#use date range

#connection.exec("SELECT sum(amount) + sum(gst) AS total_incl_gst FROM transactions #{where_clause}")

#def total_sales(month)
#  $sales_connection.stream.exec("SELECT sum(amount) + sum(gst) AS total FROM transactions WHERE date_trunc('month', timestamp) = to_date('#{month}','MM-YYYY')") do |result|
#      result.each { |row| puts row['total'] }
#  end                         
#end

#total_sales(month)



puts "======== MONTHLY REPORT | #{month} ========"
puts "\n==== Total sales for the period ==== "
connection("SELECT sum(amount) + sum(gst) AS total_incl_gst FROM transactions #{where_clause}")
# GST collected for the period.
print "\nGST collected for the period: "
connection("SELECT sum(gst) AS total_incl_gst FROM transactions #{where_clause}")
# Top 5 transactions
puts "\n==== Top 5 transactions ==== "
connection("SELECT products.name, transactions.* FROM transactions INNER JOIN products ON transactions.product_id = products.id #{where_clause} ORDER BY amount desc limit 5" )
# Products summarised by total sales desc
puts "\n==== Products summarised by total sales, desc ===="
connection("SELECT products.name, sum(transactions.amount) FROM transactions INNER JOIN products ON transactions.product_id = products.id #{where_clause} GROUP BY products.name")
# Average sale price
puts "\n==== Average sale price ==== "
connection("SELECT avg(amount::numeric)::money FROM transactions #{where_clause}")

# Best sales day
puts "\n==== Best sales day ===="
connection("SELECT date_trunc('day', timestamp), sum(amount) FROM transactions #{where_clause} GROUP BY date_trunc('day', timestamp) limit 1")

# Sales summarised by day
puts "\n==== Sales summarised by day ==== "
connection("SELECT sum(amount), date_trunc('day', timestamp) FROM transactions #{where_clause} GROUP BY date_trunc('day', timestamp)")
