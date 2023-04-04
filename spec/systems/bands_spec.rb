require "rails_helper"

RSpec.describe "bands", js: true, type: :system do
  let!(:user) { create(:user, age: 22, prefecture_id: 27) }
  let!(:band_a) { create(:band, number_of_member: 2, average_age: 20, maximum_age: 22, minimum_age: 18, prefecture_id: 27, motivation: "趣味で楽しく", original: "既存曲のコピー", want_to_copy: "リライト", frequency: "月２〜３日", available_day: "土日", activity_time: "午後") }
  let!(:band_b) { create(:band, number_of_member: 5, average_age: 40, maximum_age: 42, minimum_age: 38, prefecture_id: 26, motivation: "プロを目指す", original: "オリジナル曲", want_to_copy: "なし", frequency: "週３日以上", available_day: "いつでも", activity_time: "いつでも") }
  let(:recruit_member_a) { create(:recruit_member, band: band_a) }
  let(:recruit_member_b) { create(:recruit_member, band: band_b, age: "40代", sex: "女性", part_id: 1, level: "中級者") }

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
end
