require "rails_helper"

RSpec.describe "Notifications" do
  let!(:user) { create(:user) }
  let!(:user_a) { create(:user) }
  let!(:band) { create(:band) }
  let!(:band_a) { create(:band) }
  let(:notification) { Notification.find_by(user_id: user.id) }

  describe "GET Notifications#index" do
    context "ユーザーがログインしているとき" do
      before do
        create(:band_member, band: band, user: user, part_id: 1)
        create(:band_member, band: band_a, user: user_a, part_id: 1)
        sign_in user
      end

      it "リクエストが200 OKとなること" do
        get notifications_path
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        get notifications_path
        expect(response.body).to include("通知")
      end

      it "ユーザーから届いた新規バンド結成のスカウトが通知として表示されていること" do
        create(:scout, user: user_a, part_id: 1, scouted_user: user, scouted_part_id: 1)
        get notifications_path
        expect(response.body).to include(user_a.name)
        expect(response.body).to include("バンド結成のお誘いが届きました")
      end

      it "ユーザーから届いたバンド加入希望のスカウトが通知として表示されていること" do
        create(:scout, user: user_a, part_id: 1, scouted_user: user, scouted_band: band)
        get notifications_path
        expect(response.body).to include(user_a.name)
        expect(response.body).to include("あなたのバンドへ加入申請が届きました")
      end

      it "バンドから届いた合併申請が通知として表示されていること" do
        create(:scout, user: user_a, band: band_a, scouted_user: user, scouted_band: band)
        get notifications_path
        expect(response.body).to include(user_a.name)
        expect(response.body).to include("バンドの合併申請が届きました")
      end

      it "ユーザーから届いた自分へのお気に入りが通知として表示されていること" do
        create(:favorite, user: user_a, favorited_user: user)
        get notifications_path
        expect(response.body).to include(user_a.name)
        expect(response.body).to include("お気に入りされました")
      end

      it "ユーザーから届いた自分のバンドへのお気に入りが通知として表示されていること" do
        create(:favorite, user: user_a, band: band)
        get notifications_path
        expect(response.body).to include(user_a.name)
        expect(response.body).to include("あなたのバンドがお気に入りされました")
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get notifications_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET Notifications#unreads" do
    before do
      sign_in user
      create(:favorite, user: user_a, favorited_user: user)
    end

    it "リクエストが200 OKとなること" do
      get unreads_notifications_path
      expect(response).to have_http_status :ok
    end

    it "タイトルが正しく表示されること" do
      get unreads_notifications_path
      expect(response.body).to include("未読の通知")
    end

    it "未読の通知が表示されること" do
      get unreads_notifications_path
      expect(response.body).to include(user_a.name)
      expect(response.body).to include("お気に入りされました")
    end

    it "既読の通知が表示されないこと" do
      notification.update(read: true)
      get unreads_notifications_path
      expect(response.body).to include("通知はありません")
    end
  end
end
