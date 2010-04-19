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

class ActivationsController < ApplicationController

  def new
  end

  def create
    data = params[:file] ? params[:file] : nil 
    duration = params[:duration] ? params[:duration].to_i : 0 
    method = params[:method] ? params[:method] : nil

    if data
      activations = nil
      filename = nil

      case method
        when "Keys"
          activations = YaasWrapper::generate_devkeys(data)
          filename = "development.sig"

        when "Leases"
          activations = YaasWrapper::generate_leases(data, duration)
          filename = "lease.sig"
      end

      if activations and filename
        send_file(activations.path, :filename => filename)    
      else
        render :text => "#{method} could not be created"
      end

    else
      render :text => "No data provided"
    end

  end

end
