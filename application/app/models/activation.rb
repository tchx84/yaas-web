# Copyright Paraguay Educa 2010, Martin Abente
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#

class Activation < ActiveRecord::Base

  belongs_to :user

  def self.register(user, form_data)
    result = false
    activation_data = nil

    if form_data[:file]
      hashes_list = YaasWrapper::parse_file(form_data[:file])
      hashes_list_length = hashes_list.length

      if hashes_list_length > 0 and user.bucket_handles(hashes_list_length)

        case form_data[:method]
          when "Keys"
            activation_data = YaasWrapper::generate_devkeys(hashes_list)

          when "Leases"
            activation_data = YaasWrapper::generate_leases(hashes_list, form_data[:duration])
        end

        if activation_data
          activation = Activation.new
          activation.user_id = user.id
          activation.comments = form_data[:comments]
          activation.method = form_data[:method]
          activation.data = activation_data.join
          activation.bucket = activation_data.length
          activation.save!

          user.bucket = user.bucket - hashes_list_length
          user.save!

          result = true
        end
      end
    end

    result
  end

  def filename
    return_filename = "unnamed"

    case method

      when "Keys"
        return_filename = "development.sig"

      when "Leases"
        return_filename = "lease.sig"
    end

    return_filename
  end

end
