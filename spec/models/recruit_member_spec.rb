require "rails_helper"

RSpec.describe RecruitMember do
  let!(:recruit_member) { create(:recruit_member) }

  it "すべてのフォームを入力しているとき、その他のパート名が15文字以内であれば登録できること" do
    expect(recruit_member).to be_valid
  end

  it "その他のパート名が16文字以上であれば登録できないこと" do
    recruit_member.other_part = "test_other_part1"
    expect(recruit_member).not_to be_valid
    expect(recruit_member.errors).not_to be_empty
  end
end
