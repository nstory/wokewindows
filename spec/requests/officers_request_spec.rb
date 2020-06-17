require 'rails_helper'

RSpec.describe "Officers", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/officers/index"
      expect(response).to have_http_status(:success)
    end
  end

end
