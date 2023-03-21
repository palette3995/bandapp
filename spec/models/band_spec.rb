require "rails_helper"

RSpec.describe Band do
  let!(:band) { create(:band) }

  it "名前を入力していないとき登録できないこと" do
    band.name = nil
    expect(band).not_to be_valid
    expect(band.errors).not_to be_empty
  end

  it "その他のジャンル名が16文字以上であれば登録できないこと" do
    genre = create(:other_music)
    band_genre = create(:band_genre, band: band, genre: genre)
    band_genre.other_genre = "test_other_genre"
    expect(band_genre).not_to be_valid
    expect(band_genre.errors).not_to be_empty
  end
end
