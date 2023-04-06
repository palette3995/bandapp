require "rails_helper"

RSpec.describe "users_form", js: true, type: :system do
  let!(:user) { create(:user, age: 22, prefecture_id: 27) }

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
end
