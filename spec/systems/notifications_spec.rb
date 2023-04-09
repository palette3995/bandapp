require "rails_helper"

RSpec.describe "notifications", type: :system do
  let!(:user) { create(:user) }
  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user) }

  describe "通知のリンク先について" do
    before do
      sign_in user
    end

    it "スカウトの通知をクリックすると、スカウト一覧に遷移すること" do
      create(:scout, user: user_a, part_id: 1, scouted_user: user, scouted_part_id: 1)
      visit notifications_path
      find(".notification-link").click
      expect(page).to have_content "届いたスカウト一覧"
    end

    it "お気に入りの通知をクリックすると、お気に入り一覧に遷移すること" do
      create(:favorite, user: user_a, favorited_user: user)
      visit notifications_path
      find(".notification-link").click
      expect(page).to have_content "お気に入りユーザー一覧"
    end
  end

  describe "既読機能" do
    before do
      sign_in user
      create(:favorite, user: user_a, favorited_user: user)
    end

    it "未読の通知をクリックしたとき、既読になること" do
      visit notifications_path
      notification = Notification.find_by(read: false)
      find(".notification-link").click
      sleep 0.5
      expect(notification.reload.read).to be true
    end

    it "「全て既読にする」をクリックしたとき、全ての通知が既読になること" do
      create(:favorite, user: user_b, favorited_user: user)
      visit notifications_path
      click_link "全て既読にする"
      sleep 0.5
      expect(Notification.where(read: true).count).to eq 2
    end
  end
end
