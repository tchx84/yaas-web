class User < ActiveRecord::Base

  has_many :activations

  def bucket_handles(amount)
    result = true

    if !admin
      result = (bucket >= amount)
    end

    result
  end

end
