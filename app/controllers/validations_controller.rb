# frozen_string_literal: true

require 'services/validations/ip_validator'

# Validations Controller (handle validation actions)
class ValidationsController < ApplicationController
  def validate_ip
    result = Services::Validations::IpValidator.call(ips_params)
    render json: { data: result.data, message: result.message },
           status: result.status == :ok ? result.status : :not_acceptable
  end

  private

  def ips_params
    params.require(:ips)
  end
end
