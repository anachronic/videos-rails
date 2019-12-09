class ApiController < ApplicationController
  before_action :set_json_format

  private

  def set_json_format
    request.format = :json
  end
end
