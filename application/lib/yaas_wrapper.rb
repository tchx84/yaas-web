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

# Yet Another Activation System - Client Wrapper

module YaasWrapper

  def self.generate_devkeys(hashes_list)
    yaas_client.generate_devkeys(hashes_list)
  end

  def self.generate_leases(hashes_list, duration)
    yaas_client.generate_leases(hashes_list, duration)
  end

  def self.parse_file(file)
    hashes_list = []
    serial_numbers = {}

    file.readlines.each { |line|
      fields = line.split

      if fields.length == 3
        serial_number = fields[0]
        uuid = fields[1]

        if !serial_numbers[serial_number] and valid_serial_number(serial_number) and valid_uuid(uuid)
          #TODO: Find a better way to avoid repeated serials
          serial_numbers[serial_number] = true
          hash = {"serial_number" => serial_number.to_s, "uuid" => uuid.to_s}
          hashes_list.push(hash)
        end
      end
    }
  
    hashes_list
  end

  def self.max_activation_days
    YAAS_CONFIG['max_activation_days'] ? YAAS_CONFIG['max_activation_days'].to_i : (365*5)
  end

  private

  def self.yaas_client
    YaasClient.new(YAAS_CONFIG['server'], YAAS_CONFIG['port'], YAAS_CONFIG['host_handler'])
  end

  def self.valid_serial_number(serial_number)
    return true if serial_number.upcase.match("^[A-Z]{3}[(0-9)|(A-F)]{8}$")
    false
  end

  def self.valid_uuid(uuid)
    return true if uuid.upcase.match("^[(0-9)|(A-F)]{8}(-[(0-9)|(A-F)]{4}){3}-[(0-9)|(A-F)]{12}$")
    false
  end

end
