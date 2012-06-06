dbstruct
========

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
