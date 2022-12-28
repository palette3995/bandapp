require "rails_helper"
RSpec.describe "Sessions" do
  describe "GET /new" do
    it "レスポンスが正常であること" do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
    end
  end
end
