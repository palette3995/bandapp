require "rails_helper"

RSpec.describe "scouts", js: true, type: :system do
  let!(:user) { create(:user, age: 22, prefecture_id: 27) }
  let!(:user_a) { create(:user, age: 20, sex: "男性", prefecture_id: 27, favorite: "アジカン", motivation: "趣味で楽しく", original: "既存曲のコピー", want_to_copy: "リライト", frequency: "月２〜３日", available_day: "土日", activity_time: "午後", compose: false) }
  let!(:band) { create(:band) }
  let!(:band_a) { create(:band) }
  let(:band_member) { create(:band_member, user: user, band: band, role: "リーダー") }
  let(:band_member_a) { create(:band_member, user: user, band: band_a) }

  describe "ユーザーヘのスカウト申請画面の機能" do
    context "ユーザーからスカウトを送るとき" do
      before do
        sign_in user
        visit new_user_scout_path(user_a)
      end

      it "自分のパートのみ選択したとき、スカウト申請ボタンが非活性であること" do
        select "ボーカル", from: "scout[part_id]"
        expect(find(".btn-scout-0")).to be_disabled
      end

      it "相手のパートのみ選択したとき、スカウト申請ボタンが非活性であること" do
        select "ギター", from: "scout[scouted_part_id]"
        expect(find(".btn-scout-0")).to be_disabled
      end

      it "自分のパートと相手のパートを選択したとき、スカウト申請ボタンが活性化すること" do
        select "ボーカル", from: "scout[part_id]"
        select "ギター", from: "scout[scouted_part_id]"
        expect(find(".btn-scout-0")).not_to be_disabled
      end

      it "スカウト申請ボタンが活性状態で自分のパートを未選択にすると、ボタンが非活性化すること" do
        select "ボーカル", from: "scout[part_id]"
        select "ギター", from: "scout[scouted_part_id]"
        select "選択してください", from: "scout[part_id]"
        expect(find(".btn-scout-0")).to be_disabled
      end

      it "スカウト申請ボタンが活性状態で相手のパートを未選択にすると、ボタンが非活性化すること" do
        select "ボーカル", from: "scout[part_id]"
        select "ギター", from: "scout[scouted_part_id]"
        select "選択してください", from: "scout[scouted_part_id]"
        expect(find(".btn-scout-0")).to be_disabled
      end

      it "「所属中のバンドに誘う」をクリックすると、バンドからのスカウト画面に切り替わること" do
        page.all(".tab1__link")[1].click
        expect(page).to have_selector ".from-band"
        expect(page).not_to have_selector ".from-user"
      end
    end

    context "バンドからスカウトを送るとき" do
      before do
        sign_in user
        band_member
        band_member_a
        visit new_user_scout_path(user_a)
        page.all(".tab1__link")[1].click
      end

      it "自分がリーダーであるバンド名のみ選択できること" do
        expect(page).to have_select("scout[band_id]", options: ["選択してください", band.name])
      end

      it "自分のバンドのみ選択したとき、スカウト申請ボタンが非活性であること" do
        select band.name, from: "scout[band_id]"
        expect(find(".btn-scout-1")).to be_disabled
      end

      it "相手のパートのみ選択したとき、スカウト申請ボタンが非活性であること" do
        select "ギター", from: "scout[scouted_part_id]"
        expect(find(".btn-scout-1")).to be_disabled
      end

      it "自分のバンドと相手のパートを選択したとき、スカウト申請ボタンが活性化すること" do
        select band.name, from: "scout[band_id]"
        select "ギター", from: "scout[scouted_part_id]"
        expect(find(".btn-scout-1")).not_to be_disabled
      end

      it "スカウト申請ボタンが活性状態で自分のバンドを未選択にすると、ボタンが非活性化すること" do
        select band.name, from: "scout[band_id]"
        select "ギター", from: "scout[scouted_part_id]"
        select "選択してください", from: "scout[band_id]"
        expect(find(".btn-scout-1")).to be_disabled
      end

      it "スカウト申請ボタンが活性状態で相手のパートを未選択にすると、ボタンが非活性化すること" do
        select band.name, from: "scout[band_id]"
        select "ギター", from: "scout[scouted_part_id]"
        select "選択してください", from: "scout[scouted_part_id]"
        expect(find(".btn-scout-1")).to be_disabled
      end

      it "「新たにバンドを作成」をクリックすると、バンドからのスカウト画面に切り替わること" do
        first(".tab1__link").click
        expect(page).to have_selector ".from-user"
        expect(page).not_to have_selector ".from-band"
      end
    end
  end
end
