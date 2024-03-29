require "rails_helper"

RSpec.describe Scout do
  let!(:user) { create(:user) }
  let!(:scout) { create(:scout, part_id: 6, scouted_user: user, scouted_part_id: 6) }

  it "すべての値が適切な場合登録できること" do
    expect(scout).to be_valid
  end

  it "スカウトした人のその他のパート名が16文字以上であれば登録できないこと" do
    scout.other_part = "test_other_part1"
    expect(scout).not_to be_valid
    expect(scout.errors).not_to be_empty
  end

  it "スカウトされた人のその他のパート名が16文字以上であれば登録できないこと" do
    scout.scouted_other_part = "test_other_part1"
    expect(scout).not_to be_valid
    expect(scout.errors).not_to be_empty
  end

  it "メッセージが31文字以上であれば登録できないこと" do
    scout.message = "scout_messages_over_30_words!!!"
    expect(scout).not_to be_valid
    expect(scout.errors).not_to be_empty
  end
end
