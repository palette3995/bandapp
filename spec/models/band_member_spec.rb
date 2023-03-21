require "rails_helper"

RSpec.describe BandMember do
  let!(:part) { create(:other_inst) }
  let!(:band_member) { create(:band_member, part: part, other_part: "other_part") }

  it "すべてのフォームを入力しているとき登録できること" do
    expect(band_member).to be_valid
  end

  it "その他のパート名が16文字以上であれば登録できないこと" do
    band_member.other_part = "test_other_part1"
    expect(band_member).not_to be_valid
    expect(band_member.errors).not_to be_empty
  end
end
