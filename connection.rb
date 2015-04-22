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

  def exec(query)
    results = []
    @stream.exec(query) do |result|
      result.each { |row| results << row }
    end
    results
  end
end

#connection = Connection.new('sales')
#connection.exec("SELECT * FROM transactions")

#puts connection
