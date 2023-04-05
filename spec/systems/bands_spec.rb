require "rails_helper"

RSpec.describe "bands", js: true, type: :system do
  let!(:user) { create(:user, age: 22, prefecture_id: 27) }
  let!(:band_a) { create(:band, number_of_member: 2, average_age: 20, maximum_age: 22, minimum_age: 18, prefecture_id: 27, motivation: "趣味で楽しく", original: "既存曲のコピー", want_to_copy: "リライト", frequency: "月２〜３日", available_day: "土日", activity_time: "午後") }
  let!(:band_b) { create(:band, number_of_member: 5, average_age: 40, maximum_age: 42, minimum_age: 38, prefecture_id: 26, motivation: "プロを目指す", original: "オリジナル曲", want_to_copy: "なし", frequency: "週３日以上", available_day: "いつでも", activity_time: "いつでも") }
  let(:recruit_member_a) { create(:recruit_member, band: band_a) }
  let(:recruit_member_b) { create(:recruit_member, band: band_b, age: "40代", sex: "女性", part_id: 1, level: "中級者") }
  let(:band_member_a) { create(:band_member, user: user, band: band_a) }
  let(:reader) { create(:band_member, band: band_a, role: "リーダー") }

  describe "検索機能" do
    before do
      band_a.band_genres.first.update(genre_id: 1)
      band_a.band_genres[1].update(genre_id: 3)
      band_b.band_genres.first.update(genre_id: 2)
      band_b.band_genres[1].update(genre_id: 1)
      recruit_member_a
      recruit_member_b
      sign_in user
      visit bands_path
    end

    it "検索フォームにバンド名を入力し、検索できること" do
      fill_in "q[name_cont]", with: band_a.name
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "都道府県を選択して、バンドを検索できること" do
      select "大阪府", from: "q[prefecture_id_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "メンバー数がMINに入力した数以上のバンドが検索できること" do
      fill_in "q[number_of_member_gteq]", with: 5
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "メンバー数がMAXに入力した数以下のバンドが検索できること" do
      fill_in "q[number_of_member_lteq]", with: 2
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "メンバー数がMIN〜MAXに入力した数の範囲内のバンドが検索できること" do
      fill_in "q[number_of_member_gteq]", with: 3
      fill_in "q[number_of_member_lteq]", with: 6
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "平均年齢がMINに入力した数以上のバンドが検索できること" do
      fill_in "q[average_age_gteq]", with: 40
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "平均年齢がMAXに入力した数以下のバンドが検索できること" do
      fill_in "q[average_age_lteq]", with: 20
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "平均年齢がMIN〜MAXに入力した数の範囲内のバンドが検索できること" do
      fill_in "q[average_age_gteq]", with: 30
      fill_in "q[average_age_lteq]", with: 50
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "メンバーの最大年齢がMINに入力した数以上のバンドが検索できること" do
      fill_in "q[maximum_age_gteq]", with: 42
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "メンバーの最大年齢がMAXに入力した数以下のバンドが検索できること" do
      fill_in "q[maximum_age_lteq]", with: 18
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "メンバーの最大年齢がMIN〜MAXに入力した数の範囲内のバンドが検索できること" do
      fill_in "q[maximum_age_gteq]", with: 30
      fill_in "q[maximum_age_lteq]", with: 50
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "メンバーの最小年齢がMINに入力した数以上のバンドが検索できること" do
      fill_in "q[minimum_age_gteq]", with: 38
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "メンバーの最小年齢がMAXに入力した数以下のバンドが検索できること" do
      fill_in "q[minimum_age_lteq]", with: 18
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "メンバーの最小年齢がMIN〜MAXに入力した数の範囲内のバンドが検索できること" do
      fill_in "q[minimum_age_gteq]", with: 30
      fill_in "q[minimum_age_lteq]", with: 40
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_b.name
      expect(page).to have_no_content band_a.name
    end

    it "募集しているパート名を選択して、パート1の名前が一致するバンドを検索できること" do
      select "その他", from: "q[recruit_members_part_id_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "募集しているレベルを選択して、バンドを検索できること" do
      select "初心者", from: "q[recruit_members_level_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "募集している年齢を選択して、バンドを検索できること" do
      select "20代まで", from: "q[recruit_members_age_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "募集している性別を選択して、バンドを検索できること" do
      select "男性", from: "q[recruit_members_sex_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "ジャンル名を選択して、ジャンル1の名前が一致するバンドを検索できること" do
      select "J-POP", from: "q[band_genres_genre_id_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "「サブジャンルを含む」をチェックすると、ジャンル1以外でもジャンル名が一致するバンドを検索できること" do
      select "J-POP", from: "q[band_genres_genre_id_eq]"
      check("q_band_genres_priority_lteq")
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_content band_b.name
    end

    it "活動方針を選択して、バンドを検索できること" do
      select "趣味で楽しく", from: "q[motivation_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "楽曲の方針を選択して、バンドを検索できること" do
      select "既存曲のコピー", from: "q[original_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "検索フォームにコピーしたい楽曲名を入力し、バンドを検索できること" do
      fill_in "q[want_to_copy_cont]", with: "リライト"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "活動頻度を選択して、バンドを検索できること" do
      select "月２〜３日", from: "q[frequency_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "活動できる日を選択して、バンドを検索できること" do
      select "土日", from: "q[available_day_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end

    it "活動できる時間帯を選択して、バンドを検索できること" do
      select "午後", from: "q[activity_time_eq]"
      find_by_id("search-bands").send_keys :enter
      expect(page).to have_content band_a.name
      expect(page).to have_no_content band_b.name
    end
  end

  describe "バンド詳細画面の機能" do
    before do
      sign_in user
      reader
    end

    context "自分の所属バンドの詳細画面にアクセスしたとき" do
      before do
        band_member_a
      end

      it "バンド編集画面へのリンクが表示されること" do
        visit band_path(band_a)
        expect(page).to have_link "編集", href: edit_band_path(band_a)
      end

      it "メンバー募集新規作成へのリンクが表示されること" do
        visit band_path(band_a)
        expect(page).to have_link "新規作成", href: new_recruit_member_path(band_a)
      end

      it "メンバー募集の削除と編集画面へのリンクが表示されること" do
        recruit_member_a
        visit band_path(band_a)
        expect(page).to have_link "削除", href: recruit_member_path(recruit_member_a)
        expect(page).to have_link "編集", href: edit_recruit_member_path(recruit_member_a)
      end

      it "バンド脱退のリンクが表示されること" do
        visit band_path(band_a)
        expect(page).to have_link "脱退する", href: band_member_path(band_member_a)
      end

      it "自分がリーダーでないとき、メンバー編集画面へのリンクが表示されないこと" do
        visit band_path(band_a)
        expect(page).not_to have_link "編集", href: edit_band_member_path(band_member_a)
      end

      it "自分がリーダーのとき、メンバー編集画面へのリンクが表示されること" do
        sign_out user
        sign_in reader.user
        visit band_path(band_a)
        expect(page).to have_link "編集", href: edit_band_member_path(band_member_a)
      end

      it "お気に入り登録ボタン、スカウトボタンが表示されないこと" do
        visit band_path(band_a)
        expect(page).not_to have_link "お気に入り", href: create_band_favorite_path(band_a)
        expect(page).not_to have_link "スカウト", href: new_user_scout_path(band_a)
      end
    end

    context "所属バンド以外のバンドの詳細画面にアクセスしたとき" do
      it "バンド編集画面へのリンクが表示されないこと" do
        visit band_path(band_a)
        expect(page).not_to have_link "編集", href: edit_band_path(band_a)
      end

      it "メンバー募集新規作成へのリンクが表示されないこと" do
        visit band_path(band_a)
        expect(page).not_to have_link "新規作成", href: new_recruit_member_path(band_a)
      end

      it "メンバー募集の削除と編集画面へのリンクが表示されないこと" do
        recruit_member_a
        visit band_path(band_a)
        expect(page).not_to have_link "削除", href: recruit_member_path(recruit_member_a)
        expect(page).not_to have_link "編集", href: edit_recruit_member_path(recruit_member_a)
      end

      it "バンド脱退のリンクが表示されないこと" do
        visit band_path(band_a)
        expect(page).not_to have_link "脱退する", href: band_member_path(band_member_a)
      end

      it "メンバー編集画面へのリンクが表示されないこと" do
        visit band_path(band_a)
        expect(page).not_to have_link "編集", href: edit_band_member_path(band_member_a)
      end

      it "お気に入り登録ボタン、スカウトボタンが表示されること" do
        visit band_path(band_a)
        expect(page).to have_link "お気に入り", href: create_band_favorite_path(band_a)
        expect(page).to have_link "スカウト", href: new_band_scout_path(band_a)
      end

      it "お気に入り登録ボタンをクリックすると、表記が「お気に入り済み」になること" do
        visit band_path(band_a)
        click_link("unfavorite")
        expect(page).to have_link "お気に入り済み", href: destroy_band_favorite_path(band_a)
        expect(page).not_to have_link "お気に入り", href: create_band_favorite_path(band_a)
      end

      it "お気に入り済みのボタンをクリックすると、再度お気に入り登録ボタンに切り替わること" do
        visit band_path(band_a)
        click_link("unfavorite")
        click_link("favoriting")
        expect(page).to have_link "お気に入り", href: create_band_favorite_path(band_a)
        expect(page).not_to have_link "お気に入り済み", href: destroy_band_favorite_path(band_a)
      end
    end
  end
end
