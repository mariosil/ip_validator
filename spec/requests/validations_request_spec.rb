require 'rails_helper'

RSpec.describe "Validations", type: :request do

  describe "GET /validate_ip" do
    it "returns http success" do
      get "/validations/validate_ip"
      expect(response).to have_http_status(:success)
    end
  end

end
