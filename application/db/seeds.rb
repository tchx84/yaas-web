# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

if !User.find_by_name("admin")
  User.create({
              :name => "admin",
              :password => "admin", 
              :admin => true, 
              :email => "mabente@paraguayeduca.org",
              :bucket => 0, 
              :activation_limit => 0
              })
end
