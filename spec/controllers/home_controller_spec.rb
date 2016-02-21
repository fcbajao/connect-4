require 'rails_helper'

describe HomeController, type: :controller do
  describe "GET index" do
    before do
      get :index
    end

    it "responds with success" do
      expect(response).to have_http_status(:success)
    end
  end
end
