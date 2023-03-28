require "rails_helper"

RSpec.describe "Scouts" do
  let!(:user) { create(:user) }
  let!(:user_a) { create(:user) }
  let!(:band) { create(:band) }
  let!(:band_a) { create(:band) }
  let(:band_member) { create(:band_member, band: band, user: user, role: "リーダー") }
  let(:band_member_a) { create(:band_member, band: band_a, user: user_a, role: "リーダー") }
  let(:scout) { create(:scout, user: user_a, part_id: 1, scouted_user: user, scouted_part_id: 1) }
  let(:scout_params) { attributes_for(:scout, user_id: user.id, band_id: band.id, scouted_user_id: user_a.id, scouted_part_id: 1) }
  let(:marge_scout_params) { attributes_for(:scout, user_id: user.id, band_id: band.id, scouted_user_id: user_a.id, scouted_band_id: band_a.id) }

  describe "GET scouts#index" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        scout
        get scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "ユーザーから届いた新規バンド結成のスカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#received_join" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        create(:scout, user: user_a, part_id: 1, scouted_user: user, scouted_band: band)
        get received_join_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "ユーザーから届いたバンド加入希望のスカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_join_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#received_offer" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member_a
        create(:scout, user: user_a, band: band_a, scouted_user: user, scouted_part_id: 1)
        get received_offer_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "バンドから届いたメンバースカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_offer_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#received_marge" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:scout, user: user_a, band: band_a, scouted_user: user, scouted_band: band)
        get received_marge_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("届いたスカウト一覧")
      end

      it "バンドから届いた合併申請が表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get received_marge_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_new" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        create(:scout, user: user, part_id: 1, scouted_user: user_a, scouted_part_id: 1)
        get send_new_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "ユーザーへ送った新規バンド結成のスカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_new_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_join" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member_a
        create(:scout, user: user, part_id: 1, scouted_user: user_a, scouted_band: band_a)
        get send_join_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "バンドへ送ったメンバー加入希望のスカウトが表示されていること" do
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_join_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_offer" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        create(:scout, user: user, band: band, scouted_user: user_a, scouted_part_id: 1)
        get send_offer_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "ユーザーへ送ったバンドメンバースカウトが表示されていること" do
        expect(response.body).to include(user_a.name)
        expect(response.body).to include(band.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_offer_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#send_marge" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:scout, user: user, band: band, scouted_user: user_a, scouted_band: band_a)
        get send_marge_scouts_path
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "タイトルが正しく表示されること" do
        expect(response.body).to include("申請したスカウト一覧")
      end

      it "バンドへ送った合併申請が表示されていること" do
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get send_marge_scouts_path
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#new_user" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        get new_user_scout_path(user_a)
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "申請相手の名前が正しく表示されること" do
        expect(response.body).to include(user_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get new_user_scout_path(user_a)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "GET scouts#new_band" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member_a
        get new_band_scout_path(band_a)
      end

      it "リクエストが200 OKとなること" do
        expect(response).to have_http_status :ok
      end

      it "申請先バンドの名前が正しく表示されること" do
        expect(response.body).to include(band_a.name)
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        get new_band_scout_path(band_a)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "POST scouts#create" do
    context "スカウトが送れない条件に当てはまらないとき" do
      before do
        sign_in user
        band_member
      end

      it "リクエストが成功すること" do
        post scouts_path, params: { scout: scout_params }
        expect(response).to have_http_status :found
      end

      it "createが成功すること" do
        expect do
          post scouts_path, params: { scout: scout_params }
        end.to change(Scout, :count).by 1
      end

      it "リダイレクトされること" do
        post scouts_path, params: { scout: scout_params }
        expect(response).to redirect_to scouts_path
      end
    end

    context "既に相手ユーザーへスカウトを送っているとき" do
      before do
        sign_in user
        band_member
        create(:scout, user: user, band: band, scouted_user: user_a, scouted_part_id: 1)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post scouts_path, params: { scout: scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post scouts_path, params: { scout: scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post scouts_path, params: { scout: scout_params }
        expect(response.body).to include "既にスカウトを送っています。"
      end
    end

    context "相手から既にスカウトを受けているとき" do
      before do
        sign_in user
        band_member
        create(:scout, user: user_a, part_id: 1, scouted_band: band, scouted_user: user)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post scouts_path, params: { scout: scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post scouts_path, params: { scout: scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post scouts_path, params: { scout: scout_params }
        expect(response.body).to include "相手から既にスカウトが届いています。"
      end
    end

    context "相手が既にバンドメンバーであるとき" do
      before do
        sign_in user
        band_member
        create(:band_member, band: band, user: user_a)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post scouts_path, params: { scout: scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post scouts_path, params: { scout: scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post scouts_path, params: { scout: scout_params }
        expect(response.body).to include "既にバンドメンバーです。"
      end
    end
  end

  describe "POST scouts#create_band" do
    context "バンド合併申請のスカウトが送れない条件に当てはまらないとき" do
      before do
        sign_in user
        band_member
        band_member_a
      end

      it "リクエストが成功すること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to have_http_status :found
      end

      it "createが成功すること" do
        expect do
          post create_band_scouts_path, params: { scout: marge_scout_params }
        end.to change(Scout, :count).by 1
      end

      it "リダイレクトされること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to redirect_to scouts_path
      end
    end

    context "バンドから既に相手バンドへスカウトを送っているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:scout, user: user, band: band, scouted_band: band_a)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post create_band_scouts_path, params: { scout: marge_scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response.body).to include "既にスカウトを送っています。"
      end
    end

    context "相手バンドから既にスカウトを受けているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:scout, user: user_a, band: band_a, scouted_band: band)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post create_band_scouts_path, params: { scout: marge_scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response.body).to include "相手から既にスカウトが届いています。"
      end
    end

    context "他のバンドメンバーが既に相手バンドへスカウトを送っているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        member = create(:band_member, band: band)
        create(:scout, user: member.user, part_id: 1, scouted_band: band_a)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post create_band_scouts_path, params: { scout: marge_scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response.body).to include "既にスカウトを送っています。"
      end
    end

    context "相手バンドと共通のメンバーがいるとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create(:band_member, user: user_a, band: band)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post create_band_scouts_path, params: { scout: marge_scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response.body).to include "共通のメンバーがいる為スカウトを送れません。"
      end
    end

    context "申請元バンドと相手バンドのメンバー数が合計で10人を超えるとき" do
      before do
        sign_in user
        band_member
        band_member_a
        create_list(:band_member, 5, band: band)
        create_list(:band_member, 4, band: band_a)
      end

      it "リクエストが422 unprocessable_entityになること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response).to have_http_status :unprocessable_entity
      end

      it "createが失敗すること" do
        expect do
          post create_band_scouts_path, params: { scout: marge_scout_params }
        end.not_to change(Scout, :count)
      end

      it "エラーが表示されること" do
        post create_band_scouts_path, params: { scout: marge_scout_params }
        expect(response.body).to include "バンドメンバーが10人を超える為スカウトを送れません。"
      end
    end
  end

  describe "DELETE scouts#approve_new" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        scout
      end

      it "リクエストが成功すること" do
        delete approve_new_scout_path(scout)
        expect(response).to have_http_status :found
      end

      it "スカウトが削除されること" do
        expect do
          delete approve_new_scout_path(scout)
        end.to change(Scout, :count).by(-1)
      end

      it "バンドが作成され、スカウトした人とされた人がメンバーになること" do
        expect do
          delete approve_new_scout_path(scout)
        end.to change(Band, :count).by(1)
                                   .and change(user.bands, :count).by(1)
                                                                  .and change(user_a.bands, :count).by(1)
      end

      it "リダイレクトされること" do
        delete approve_new_scout_path(scout)
        expect(response).to redirect_to bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        delete approve_new_scout_path(scout)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "DELETE scouts#approve_offer" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member_a
        scout.update(band: band_a, part_id: nil)
      end

      it "リクエストが成功すること" do
        delete approve_offer_scout_path(scout)
        expect(response).to have_http_status :found
      end

      it "スカウトが削除されること" do
        expect do
          delete approve_offer_scout_path(scout)
        end.to change(Scout, :count).by(-1)
      end

      it "スカウトされた人がスカウトしたバンドのメンバーになること" do
        expect do
          delete approve_offer_scout_path(scout)
        end.to change(band_a.band_members, :count).by(1)
                                                  .and change(user.bands, :count).by(1)
      end

      it "リダイレクトされること" do
        delete approve_offer_scout_path(scout)
        expect(response).to redirect_to bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        delete approve_offer_scout_path(scout)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "DELETE scouts#approve_join" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        scout.update(scouted_band: band, scouted_part_id: nil)
      end

      it "リクエストが成功すること" do
        delete approve_join_scout_path(scout)
        expect(response).to have_http_status :found
      end

      it "スカウトが削除されること" do
        expect do
          delete approve_join_scout_path(scout)
        end.to change(Scout, :count).by(-1)
      end

      it "スカウトした人がスカウトされたバンドのメンバーになること" do
        expect do
          delete approve_join_scout_path(scout)
        end.to change(band.band_members, :count).by(1)
                                                .and change(user_a.bands, :count).by(1)
      end

      it "リダイレクトされること" do
        delete approve_join_scout_path(scout)
        expect(response).to redirect_to bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        delete approve_join_scout_path(scout)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "DELETE scouts#approve_marge" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        band_member
        band_member_a
        scout.update(band: band_a, scouted_band: band, scouted_part_id: nil, part_id: nil)
      end

      it "リクエストが成功すること" do
        delete approve_marge_scout_path(scout)
        expect(response).to have_http_status :found
      end

      it "スカウトが削除されること" do
        expect do
          delete approve_marge_scout_path(scout)
        end.to change(Scout, :count).by(-1)
      end

      it "スカウトしたバンド、スカウトされたバンドが共に削除されること" do
        delete approve_marge_scout_path(scout)
        expect(Band.all).not_to include band
        expect(Band.all).not_to include band_a
      end

      it "スカウトしたバンドとされたバンドが合併して新バンドが作成されること" do
        delete approve_marge_scout_path(scout)
        new_band = Band.find_by(name: "新規バンド")
        expect(user.bands).to include new_band
        expect(user_a.bands).to include new_band
      end

      it "リダイレクトされること" do
        delete approve_marge_scout_path(scout)
        expect(response).to redirect_to bands_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        delete approve_marge_scout_path(scout)
        expect(response).to have_http_status :found
      end
    end
  end

  describe "DELETE scouts#refuse" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        scout
      end

      it "リクエストが成功すること" do
        delete refuse_scout_path(scout)
        expect(response).to have_http_status :found
      end

      it "スカウトが削除されること" do
        expect do
          delete refuse_scout_path(scout)
        end.to change(Scout, :count).by(-1)
      end

      it "リダイレクトされること" do
        delete refuse_scout_path(scout)
        expect(response).to redirect_to scouts_path
      end
    end

    context "ユーザーがログインしていないとき" do
      it "ログインページに遷移すること" do
        delete refuse_scout_path(scout)
        expect(response).to have_http_status :found
      end
    end
  end
end
