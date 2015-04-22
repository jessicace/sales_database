class Connection
  attr_accessor :database_name

  def initialize(database_name)
    open = PG.connect( dbname: database_name )
  end
end
