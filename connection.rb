require 'rubygems'
require 'pg'

class Connection
  attr_accessor :database_name, :stream

  def initialize(database_name)
    @database_name = database_name
    @stream = PG.connect( dbname: database_name )
  end

  def to_s
    "Connected to #{@database_name.capitalize} database"
  end
end

connection = Connection.new('sales')
#connection.stream.exec("SELECT * FROM transactions") do |result|
#  result.each do |row|
#    p row
#  end
#end

puts connection
