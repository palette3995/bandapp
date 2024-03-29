require "rails_helper"

RSpec.describe "users_form", js: true, type: :system do
  let!(:user) { create(:user) }

  describe "パート入力フォームの表示機能" do
    before do
      sign_in user
      visit edit_user_path(user)
    end

    context "パートが未選択のとき" do
      it "パート１のフォームだけが表示されること" do
        expect(page).to have_select("user[user_parts_attributes][0][part_id]", selected: "未選択")
        expect(page).not_to have_select "user[user_parts_attributes][1][part_id]"
        expect(page).not_to have_select "user[user_parts_attributes][2][part_id]"
      end

      it "パート1を選択したとき、レベル選択フォームが表示されること" do
        select "ボーカル", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][0][level]", selected: "レベル")
        expect(page).not_to have_field "user[user_parts_attributes][0][other_part]"
      end

      it "パート１を選択すると、パート2のフォームが表示されること" do
        select "ボーカル", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][1][part_id]", selected: "未選択")
        expect(page).not_to have_select "user[user_parts_attributes][2][part_id]"
      end

      it "「その他」を選択したとき、レベル選択、パート名入力フォームが表示されること" do
        select "その他", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][0][level]", selected: "レベル")
        expect(page).to have_field "user[user_parts_attributes][0][other_part]"
      end

      it "「その他」から他の選択肢に変えたとき、パート名入力フォームが非表示になること" do
        select "その他", from: "user[user_parts_attributes][0][part_id]"
        select "ボーカル", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][0][level]", selected: "レベル")
        expect(page).not_to have_field "user[user_parts_attributes][0][other_part]"
      end
    end

    context "パート1を選択済みのとき" do
      before do
        first_part
      end

      it "パート2を選択すると、パート3のフォームが表示されること" do
        select "ギター", from: "user[user_parts_attributes][1][part_id]"
        expect(page).to have_select("user[user_parts_attributes][2][part_id]", selected: "未選択")
      end

      it "パート1を未選択に変更すると、パート2のフォームが非表示になること" do
        select "未選択", from: "user[user_parts_attributes][0][part_id]"
        expect(page).not_to have_select "user[user_parts_attributes][1][part_id]"
      end

      it "パート1を未選択に変更すると、レベルとその他のパート名が初期化されること" do
        select "未選択", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][0][level]", selected: "レベル", visible: :hidden)
        expect(page).to have_field("user[user_parts_attributes][0][other_part]", with: "", visible: :hidden)
      end
    end

    context "パート2まで選択済みのとき" do
      before do
        first_part
        second_part
      end

      it "パート2を未選択に変更すると、パート3のフォームが非表示になること" do
        select "未選択", from: "user[user_parts_attributes][1][part_id]"
        expect(page).not_to have_select "user[user_parts_attributes][2][part_id]"
      end

      it "パート2を未選択に変更すると、レベルとその他のパート名が初期化されること" do
        select "未選択", from: "user[user_parts_attributes][1][part_id]"
        expect(page).to have_select("user[user_parts_attributes][1][level]", selected: "レベル", visible: :hidden)
        expect(page).to have_field("user[user_parts_attributes][1][other_part]", with: "", visible: :hidden)
      end

      it "パート1を未選択に変更すると、パート2とパート3のフォームが非表示になること" do
        select "未選択", from: "user[user_parts_attributes][0][part_id]"
        expect(page).not_to have_select "user[user_parts_attributes][1][part_id]"
        expect(page).not_to have_select "user[user_parts_attributes][2][part_id]"
      end

      it "パート1を未選択に変更すると、パート2のフォームの値が初期化されること" do
        select "未選択", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][1][level]", selected: "レベル", visible: :hidden)
        expect(page).to have_field("user[user_parts_attributes][1][other_part]", with: "", visible: :hidden)
      end
    end

    context "パート3まで選択済みのとき" do
      before do
        first_part
        second_part
        third_part
      end

      it "パート3を未選択に変更すると、レベルとその他のパート名が初期化されること" do
        select "未選択", from: "user[user_parts_attributes][2][part_id]"
        expect(page).to have_select("user[user_parts_attributes][2][level]", selected: "レベル", visible: :hidden)
        expect(page).to have_field("user[user_parts_attributes][2][other_part]", with: "", visible: :hidden)
      end

      it "パート1を未選択に変更すると、パート3のフォームの値が初期化されること" do
        select "未選択", from: "user[user_parts_attributes][0][part_id]"
        expect(page).to have_select("user[user_parts_attributes][2][level]", selected: "レベル", visible: :hidden)
        expect(page).to have_field("user[user_parts_attributes][2][other_part]", with: "", visible: :hidden)
      end

      it "パート2を未選択に変更すると、パート3のフォームの値が初期化されること" do
        select "未選択", from: "user[user_parts_attributes][1][part_id]"
        expect(page).to have_select("user[user_parts_attributes][2][level]", selected: "レベル", visible: :hidden)
        expect(page).to have_field("user[user_parts_attributes][2][other_part]", with: "", visible: :hidden)
      end
    end
  end

  describe "ジャンル入力フォームの表示機能" do
    before do
      sign_in user
      visit edit_user_path(user)
    end

    context "ジャンルが未選択のとき" do
      it "ジャンル１のフォームだけが表示されること" do
        expect(page).to have_select("user[user_genres_attributes][0][genre_id]", selected: "未選択")
        expect(page).not_to have_select "user[user_genres_attributes][1][genre_id]"
        expect(page).not_to have_select "user[user_genres_attributes][2][genre_id]"
      end

      it "ジャンル１を選択すると、ジャンル2のフォームが表示されること" do
        select "J-POP", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).to have_select("user[user_genres_attributes][1][genre_id]", selected: "未選択")
        expect(page).not_to have_select "user[user_genres_attributes][2][genre_id]"
      end

      it "「その他」を選択したとき、ジャンル名入力フォームが表示されること" do
        select "その他", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).to have_field "user[user_genres_attributes][0][other_genre]"
      end

      it "「その他」から他の選択肢に変えたとき、ジャンル名入力フォームが非表示になること" do
        select "その他", from: "user[user_genres_attributes][0][genre_id]"
        select "J-POP", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).not_to have_field "user[user_genres_attributes][0][other_genre]"
      end
    end

    context "ジャンル1を選択済みのとき" do
      before do
        first_genre
      end

      it "ジャンル2を選択すると、ジャンル3のフォームが表示されること" do
        select "アニメ", from: "user[user_genres_attributes][1][genre_id]"
        expect(page).to have_select("user[user_genres_attributes][2][genre_id]", selected: "未選択")
      end

      it "ジャンル1を未選択に変更すると、ジャンル2のフォームが非表示になること" do
        select "未選択", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).not_to have_select "user[user_genres_attributes][1][genre_id]"
      end

      it "ジャンル1を未選択に変更すると、その他のジャンル名が初期化されること" do
        select "未選択", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).to have_field("user[user_genres_attributes][0][other_genre]", with: "", visible: :hidden)
      end
    end

    context "ジャンル2まで選択済みのとき" do
      before do
        first_genre
        second_genre
      end

      it "ジャンル2を未選択に変更すると、ジャンル3のフォームが非表示になること" do
        select "未選択", from: "user[user_genres_attributes][1][genre_id]"
        expect(page).not_to have_select "user[user_genres_attributes][2][genre_id]"
      end

      it "ジャンル2を未選択に変更すると、その他のジャンル名が初期化されること" do
        select "未選択", from: "user[user_genres_attributes][1][genre_id]"
        expect(page).to have_field("user[user_genres_attributes][1][other_genre]", with: "", visible: :hidden)
      end

      it "ジャンル1を未選択に変更すると、ジャンル2とジャンル3のフォームが非表示になること" do
        select "未選択", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).not_to have_select "user[user_genres_attributes][1][genre_id]"
        expect(page).not_to have_select "user[user_genres_attributes][2][genre_id]"
      end

      it "ジャンル1を未選択に変更すると、ジャンル2のフォームの値が初期化されること" do
        select "未選択", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).to have_field("user[user_genres_attributes][1][other_genre]", with: "", visible: :hidden)
      end
    end

    context "ジャンル3まで選択済みのとき" do
      before do
        first_genre
        second_genre
        third_genre
      end

      it "ジャンル3を未選択に変更すると、その他のジャンル名が初期化されること" do
        select "未選択", from: "user[user_genres_attributes][2][genre_id]"
        expect(page).to have_field("user[user_genres_attributes][2][other_genre]", with: "", visible: :hidden)
      end

      it "ジャンル1を未選択に変更すると、ジャンル3のフォームの値が初期化されること" do
        select "未選択", from: "user[user_genres_attributes][0][genre_id]"
        expect(page).to have_field("user[user_genres_attributes][2][other_genre]", with: "", visible: :hidden)
      end

      it "ジャンル2を未選択に変更すると、ジャンル3のフォームの値が初期化されること" do
        select "未選択", from: "user[user_genres_attributes][1][genre_id]"
        expect(page).to have_field("user[user_genres_attributes][2][other_genre]", with: "", visible: :hidden)
      end
    end
  end
end
