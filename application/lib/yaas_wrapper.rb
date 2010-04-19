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

require 'tempfile'

module YaasWrapper

  def self.generate_devkeys(data)
    hashes_list = parse_data(data)
    devkeys = yaas_client.generate_devkeys(hashes_list)
    prepare_file(devkeys)
  end

  def self.generate_leases(data, duration)
    if duration and duration > 0
      hashes_list = parse_data(data)
      leases  = yaas_client.generate_leases(hashes_list, duration)
      prepare_file(leases)
    else
      nil
    end
  end

  private

  def self.prepare_file(activations)
    tempfile = Tempfile.new('activations')
    tempfile.write(activations)
    tempfile.close
    tempfile
  end

  def self.yaas_client
    YaasClient.new(YAAS_CONFIG['server'], YAAS_CONFIG['port'], YAAS_CONFIG['host_handler'])
  end

  def self.parse_data(data)
    hashes_list = []

    data.readlines.map { |line|
      fields = line.split
      hash = {"serial_number" => fields[0].to_s, "uuid" => fields[1].to_s}
      hashes_list.push(hash)
    }
  
    hashes_list
  end

end
