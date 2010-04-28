class AddAdminUser < ActiveRecord::Migration
  def self.up

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
  end

  def self.down
  end
end
