class User < ActiveRecord::Base

  has_many :activations

  validates_length_of :name, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :name, :email, :password, :bucket, :activation_limit
  validates_uniqueness_of :name, :email
  validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "Invalid email"

  def bucket_handles(amount)
    result = true

    if !admin
      result = (bucket >= amount)
    end

    result
  end

  def reduce_bucket(amount)
    if !admin
      self.bucket = self.bucket - amount
      return self.save
    end

    true
  end

  def within_limits(amount)
    if !admin
      return (1..activation_limit).include?(amount)
    end

    true
  end

end
