require 'rubygems'
require 'sinatra'
require 'active_record'

class Column
  attr_accessor :name, :sql_type, :default, :null

  def initialize( adapter_column )
    @name     = adapter_column.name
    @sql_type = adapter_column.sql_type
    @default  = adapter_column.default || 'no default'
    @null     = adapter_column.null ? 'NULL' : 'NOT NULL'
    @type     = adapter_column.type

    @opts  = []
    @opts << ", :null => false"                            unless adapter_column.null
    if [:string, :text].include? adapter_column.type
      @opts << ", :default => '#{adapter_column.default}'" if adapter_column.default
    else
      @opts << ", :default => #{adapter_column.default}"   if adapter_column.default
    end
    @opts << ", :precision => #{adapter_column.precision}" if adapter_column.precision
    @opts << ", :scale => #{adapter_column.scale}"         if adapter_column.scale
    @opts << ", :limit => #{adapter_column.limit}"         if adapter_column.limit && adapter_column.type == :string && adapter_column.limit != 255
  end

  def <=>(other)
    @name <=> other.name
  end
end

class Table
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end

  # Returns an array of columns in the table.
  def columns
    ActiveRecord::Base.connection.columns(@name).map {|c| Column.new(c) }
  end
end

# Returns array of database connection names.
# Reads the +database_configs.yml+ file for connections.
def database_connections
  yml = YAML::load(File.read('database_configs.yml'))
  yml['databases'].keys.sort
end

# Returns a Hash of connection parameters for a given connection.
def get_connection_params_for(db_name)
  yml = YAML::load(File.read('database_configs.yml'))
  yml['databases'][db_name]
end

# Returns a sorted array of Table objects for a given database connection.
def list_of_tables(base_connection)
  tables = []
  ActiveRecord::Base.establish_connection base_connection
  ActiveRecord::Base.connection.tables.each do |t|
    tables << Table.new(t)
  end
  tables.sort_by {|t| t.name }
end

#----------------------------------------------------------

get '/' do
  @databases = database_connections
  
  erb :index
end

post '/show' do
  @db_name = params['db_name']
  ActiveRecord::Base.configurations[@db_name] = get_connection_params_for(@db_name)
  @tables  = list_of_tables(@db_name)

  erb :listsorted
end

__END__

@@ index
<!doctype html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Database Structure</title>
    <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico">
  </head>
  <body>
    <h1>Choose a database</h1>
    <form action="show", method="post">
      <select name='db_name'>
        <% @databases.each do |db| %>
        <option value="<%= db %>"><%= db %></option>
        <% end %>
      </select>
      <input type="submit", value="Show structure" />
    </form>
  </body>
</html>


@@ listsorted
<!doctype html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><%= @db_name %> db: Tables with sorted fields</title>
    <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico">
    <style type="text/css">
      body { font-family: Arial, Helvetica, sans-serif; }
      table {border-collapse:collapse;} td {padding: 0 12px; color: #444;} th {color: #303030; font-size:120%; background:#B0C5E0; padding: 4px 8px 8px; text-align:left; border-top: thin solid #bbb; border-left: thin solid #bbb; border-bottom: thin solid #555; border-right: thin solid #555;} tr.data:hover {background:#B0C5E0;} #navigation { height: 400px; overflow-y: auto; border: thin solid #333; margin-top: 10px; padding-right: 10px; } #navigation li:hover { background: #B0C5E0; } #navigation ul { list-style: none; padding:0 10px; } .letter {font-size:20px;background:#B0C5E0;padding-left:20px;color:#333;border-bottom:thin solid #999;border-top:thin solid #aaa;} #navigation a {text-decoration: none; } .tables_list {float:left;} h2 {margin:0;padding:0;} div.rightbox {float:left;margin-left:20px;} div.fixbox {position:fixed;} strong {padding-left:10px;} .backlink {padding-left:10px;font-size:smaller;text-decoration: none;}
    </style>
  </head>
  <body>

    <div id="content">
      <h2>Tables in <em><%= @db_name %></em> with fields sorted alphabetically</h2>
      <br />
      <div class="tables_list">
        <table>
          <% @tables.each do |table| %>
          <tr><th colspan="4"><a name="<%= table.name %>"><%= table.name %></a></th></tr>
          <% table.columns.sort.each do |column| %>
          <tr class="data">
            <td><strong><%= column.name %></strong></td><td><i><%= column.sql_type %></i></td><td><%= column.null %></td><td><%= column.default %></td>
          </tr>
          <% end %>
          <tr><td colspan="4">&nbsp;</td></tr>
          <% end %>
        </table>
      </div>

      <div class="rightbox">
        <div class="fixbox">
          <strong><%= @db_name %></strong>
          <br />
          <a href="/" class="backlink">&laquo; Choose another database</a>
          <br />
          <div id="navigation">
            <ul>
              <% prev_l = '' %>
              <% @tables.each do |table| %>
              <% if table.name[0,1] != prev_l %>
              <% prev_l = table.name[0,1] %>
              <li class="letter"><b><%=table.name[0,1].upcase %></b></li>
              <% end %>
              <li><a href='#<%=table.name %>'><%=table.name %></a></li>
              <% end %>
            </ul>
          </div>
        </div>
      </div>
    </div>

  </body>
</html>

