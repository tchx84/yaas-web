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
  attr_accessor :duration

  def self.custom_new(user, form_data)
    activation_data = nil

    activation = Activation.new
    activation.user_id = user.id
    activation.comments = form_data[:comments]
    activation.method = form_data[:method]
    activation.duration = form_data[:duration]

    if form_data[:file]
      hashes_list = YaasWrapper::parse_file(form_data[:file])
      hashes_list_length = hashes_list.length

      if hashes_list_length > 0

        if user.bucket_handles(hashes_list_length)

          case form_data[:method]
            when "Keys"
              activation_data = YaasWrapper::generate_devkeys(hashes_list)

            when "Leases"
              if user.within_limits(form_data[:duration])
                activation_data = YaasWrapper::generate_leases(hashes_list, activation.duration)
              else
                activation.errors.add_to_base _("Duration must be within 1 and %d days") % user.activation_limit
              end
          end

          if activation_data
            activation.data = activation_data.join
            activation.bucket = activation_data.length
          else
            activation.errors.add_to_base _("Activation's backend reported a problem")
          end
        else
          activation.errors.add_to_base _("Your activation's bucket is not enough")
        end
      else
        activation.errors.add_to_base _("The data file you provided has no valid elements")
      end
    else
      activation.errors.add_to_base _("You need to provide a data file")
    end

    activation
  end

  def filename
    return_filename = "unnamed"

    case method

      when "Keys"
        return_filename = "develop.sig"

      when "Leases"
        return_filename = "lease.sig"
    end

    return_filename
  end

  def after_save
    self.user.reduce_bucket(self.bucket)
  end

end
