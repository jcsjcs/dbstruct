dbstruct and tablemigrations
============================

Choose a database and view its tables in a browser.

dbstruct displays each table as comparable text.

tablemigrations displays each table as Rails migration and scaffold generator code.

dbstruct
--------

A Sinatra app using ActiveRecord to display database structure in an easy-to-compare manner.

(Modified from code posted by Alan deLevie at [Database documentation in 50 lines of Sinatra](http://www.alandelevie.com/2010/10/26/database-documentation-in-50-lines-of-sinatra/))

To set up:

*  Rename database_configs.yml.example to database_configs.yml
*  Fill in any number of database connections in the same format as for `database.yml` in a Rails app.
*  Install Sinatra and ActiveRecord gems if required: `sudo gem install sinatra`, `sudo gem install activerecord`.
*  Start the app: `ruby dbstruct.rb`
*  Browse to: [localhost:4567](http://localhost:4567)

The output is in the form of a list of tables in alphabetic order each with its fields listed in alphabetic order.
The text is very suitable for comparing in a diff viewer.

e.g.
<table>
<tr><th colspan="4"><a name="countries">countries</a></th></tr>
<tr class="data"> <td><strong>created_at</strong></td><td><i>datetime</i></td><td>NULL</td><td>no default</td> </tr>
<tr class="data"> <td><strong>id</strong></td><td><i>int(11)</i></td><td>NOT NULL</td><td>no default</td> </tr>
<tr class="data"> <td><strong>name</strong></td><td><i>varchar(255)</i></td><td>NULL</td><td>no default</td> </tr>
<tr class="data"> <td><strong>updated_at</strong></td><td><i>datetime</i></td><td>NULL</td><td>no default</td> </tr>
</table>

tablemigrations
---------------

A Sinatra app to display tables as migrations - useful to grab migration code to generate a table that exists in another database.

To use:

*  Start the app: `ruby tablemigrations.rb`
*  Browse to: [localhost:4567](http://localhost:4567)

The output is in the form of a list of tables in alphabetic order each with a Rails migration `create_table` block and a scaffold generator command.
The generator command uses the Rails 3.2+ code for decimals with precision and scale and also appends the `--old-style-hash` option.

e.g.

**drivers**

    create_table :drivers do |t|
      t.references :tour
      t.string :contact_person
      t.string :address
      t.string :telephone_numbers
      t.string :fax_number
      t.string :cell_numbers
      t.string :email_address
      t.string :second_email_address
      t.decimal :daily_fee, :precision => 8, :scale => 2
      t.decimal :meal_allowance, :precision => 8, :scale => 2
      t.decimal :accommodation_allowance, :precision => 8, :scale => 2
      t.references :tour_operator
      t.timestamps
    end

    rails g scaffold Driver tour:references contact_person:string address:string
    telephone_numbers:string fax_number:string cell_numbers:string email_address:string
    second_email_address:string daily_fee:decimal{8.2} meal_allowance:decimal{8.2}
    accommodation_allowance:decimal{8.2} tour_operator:references --old-style-hash
