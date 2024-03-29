require "rails_helper"

RSpec.describe User do
  let!(:user) { create(:user) }

  it "すべてのフォームを入力しているとき登録できること" do
    expect(user).to be_valid
  end

  it "名前を入力していないとき登録できないこと" do
    user.name = nil
    expect(user).not_to be_valid
    expect(user.errors).not_to be_empty
  end

  it "メールアドレスを入力していないとき登録できないこと" do
    user.email = nil
    expect(user).not_to be_valid
    expect(user.errors).not_to be_empty
  end

  it "パスワードを入力していないとき登録できないこと" do
    user.password = nil
    expect(user).not_to be_valid
    expect(user.errors).not_to be_empty
  end

  it "重複したメールアドレスが存在するとき登録できないこと" do
    user_a = create(:user)
    user.email = user_a.email
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "パスワードが6文字以上であれば登録できること" do
    user.password = "test01"
    user.encrypted_password = "test01"
    expect(user).to be_valid
  end

  it "その他のパート名が16文字以上であれば登録できないこと" do
    user_part = user.user_parts.first
    user_part.part_id = 6
    user_part.other_part = "test_other_part1"
    expect(user_part).not_to be_valid
    expect(user_part.errors).not_to be_empty
  end

  it "その他のジャンル名が16文字以上であれば登録できないこと" do
    user_genre = user.user_genres.first
    user_genre.genre_id = 15
    user_genre.other_genre = "test_other_genre"
    expect(user_genre).not_to be_valid
    expect(user_genre.errors).not_to be_empty
  end
end
