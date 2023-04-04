require "rails_helper"

RSpec.describe "users", js: true, type: :system do
  let!(:user) { create(:user, age: 22, prefecture_id: 27) }
  let!(:user_a) { create(:user, age: 20, sex: "男性", prefecture_id: 27, favorite: "アジカン", motivation: "趣味で楽しく", original: "既存曲のコピー", want_to_copy: "リライト", frequency: "月２〜３日", available_day: "土日", activity_time: "午後", compose: false) }
  let!(:user_b) { create(:user, age: 40, sex: "女性", prefecture_id: 26, favorite: "特になし", motivation: "プロを目指す", original: "オリジナル曲", want_to_copy: "なし", frequency: "週３日以上", available_day: "いつでも", activity_time: "いつでも", compose: true) }

  describe "検索機能" do
    before do
      user_a.user_parts.first.update(part_id: 1, level: "初心者")
      user_a.user_parts[1].update(part_id: 3, level: "未経験")
      user_b.user_parts.first.update(part_id: 2, level: "上級者")
      user_b.user_parts[1].update(part_id: 1, level: "中級者")
      user_a.user_genres.first.update(genre_id: 1)
      user_a.user_genres[1].update(genre_id: 3)
      user_b.user_genres.first.update(genre_id: 2)
      user_b.user_genres[1].update(genre_id: 1)
      sign_in user
      visit users_path
    end

    it "検索フォームにユーザー名を入力し、検索できること" do
      fill_in "q[name_cont]", with: user_a.name
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "都道府県を選択して、ユーザーを検索できること" do
      select "大阪府", from: "q[prefecture_id_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "MINに入力した年齢以上のユーザーが検索できること" do
      fill_in "q[age_gteq]", with: 30
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_b.name
      expect(page).to have_no_content user_a.name
    end

    it "MAXに入力した年齢以下のユーザーが検索できること" do
      fill_in "q[age_lteq]", with: 30
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "MIN〜MAXに入力した年齢の範囲内のユーザーが検索できること" do
      fill_in "q[age_gteq]", with: 20
      fill_in "q[age_lteq]", with: 39
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "パート名を選択して、パート1の名前が一致するユーザーを検索できること" do
      select "ボーカル", from: "q[user_parts_part_id_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "「サブパートを含む」をチェックすると、パート1以外でもパート名が一致するユーザーを検索できること" do
      select "ボーカル", from: "q[user_parts_part_id_eq]"
      check("q_user_parts_priority_lteq")
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_content user_b.name
    end

    it "レベルを選択して、ユーザーを検索できること" do
      select "初心者", from: "q[user_parts_level_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "ジャンル名を選択して、ジャンル1の名前が一致するユーザーを検索できること" do
      select "J-POP", from: "q[user_genres_genre_id_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "「サブジャンルを含む」をチェックすると、ジャンル1以外でもジャンル名が一致するユーザーを検索できること" do
      select "J-POP", from: "q[user_genres_genre_id_eq]"
      check("q_user_genres_priority_lteq")
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_content user_b.name
    end

    it "性別を選択して、ユーザーを検索できること" do
      select "男性", from: "q[sex_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "活動方針を選択して、ユーザーを検索できること" do
      select "趣味で楽しく", from: "q[motivation_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "楽曲の方針を選択して、ユーザーを検索できること" do
      select "既存曲のコピー", from: "q[original_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "検索フォームに好きなアーティスト名を入力し、ユーザーを検索できること" do
      fill_in "q[favorite_cont]", with: "アジカン"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "検索フォームにコピーしたい楽曲名を入力し、ユーザーを検索できること" do
      fill_in "q[want_to_copy_cont]", with: "リライト"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "活動頻度を選択して、ユーザーを検索できること" do
      select "月２〜３日", from: "q[frequency_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "活動できる日を選択して、ユーザーを検索できること" do
      select "土日", from: "q[available_day_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "活動できる時間帯を選択して、ユーザーを検索できること" do
      select "午後", from: "q[activity_time_eq]"
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end

    it "「できる」を選択すると、作曲ができるユーザーを検索できること" do
      choose("q_compose_eq_true")
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_b.name
      expect(page).to have_no_content user_a.name
    end

    it "「できない」を選択すると、作曲ができないユーザーを検索できること" do
      choose("q_compose_eq_false")
      find_by_id("search-users").send_keys :enter
      expect(page).to have_content user_a.name
      expect(page).to have_no_content user_b.name
    end
  end

  describe "ユーザー詳細画面の機能" do
    before do
      sign_in user
    end

    context "自分の詳細画面にアクセスしたとき" do
      it "マイページ編集画面へのリンクが表示されること" do
        visit user_path(user)
        expect(page).to have_link "マイページを編集", href: edit_user_path(user)
      end

      it "お気に入り登録ボタン、スカウトボタンが表示されないこと" do
        expect(page).not_to have_link "お気に入り", href: create_user_favorite_path(user)
        expect(page).not_to have_link "スカウト", href: new_user_scout_path(user)
      end
    end

    context "自分以外のユーザーの詳細画面にアクセスしたとき" do
      before do
        visit user_path(user_a)
      end

      it "編集画面へのリンクが表示されないこと" do
        expect(page).not_to have_link "マイページを編集", href: edit_user_path(user)
        expect(page).not_to have_link "マイページを編集", href: edit_user_path(user_a)
      end

      it "お気に入り登録ボタン、スカウトボタンが表示されること" do
        expect(page).to have_link "お気に入り", href: create_user_favorite_path(user_a)
        expect(page).to have_link "スカウト", href: new_user_scout_path(user_a)
      end

      it "お気に入り登録ボタンをクリックすると、表記が「お気に入り済み」になること" do
        click_link("unfavorite")
        expect(page).to have_link "お気に入り済み", href: favorite_path(user_a)
        expect(page).not_to have_link "お気に入り", href: create_user_favorite_path(user_a)
      end

      it "お気に入り済みのボタンをクリックすると、再度お気に入り登録ボタンに切り替わること" do
        click_link("unfavorite")
        click_link("favoriting")
        expect(page).to have_link "お気に入り", href: create_user_favorite_path(user_a)
        expect(page).not_to have_link "お気に入り済み", href: favorite_path(user_a)
      end
    end
  end
end
