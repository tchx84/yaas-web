class AddAdminUser < ActiveRecord::Migration
  def self.up

    if !User.find_by_name("admin")
      User.create!({
                    :name => "admin",
                    :password => "admin", 
                    :admin => true, 
                    :email => "yaas@paraguayeduca.org",
                    :bucket => 1,
                    :activation_limit => 1
                  })
    end
  end

  def self.down
  end
end
