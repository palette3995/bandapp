require "rails_helper"

RSpec.describe Band do
  let!(:band) { create(:band) }
  let(:band_genre) { band.band_genres.first }

  it "名前が入力されており、その他のジャンル名が15文字以内であれば登録できること" do
    expect(band).to be_valid
  end

  it "名前を入力していないとき登録できないこと" do
    band.name = nil
    expect(band).not_to be_valid
    expect(band.errors).not_to be_empty
  end

  it "その他のジャンル名が16文字以上であれば登録できないこと" do
    band_genre.genre_id = 15
    band_genre.other_genre = "test_other_genre"
    expect(band_genre).not_to be_valid
    expect(band_genre.errors).not_to be_empty
  end
end
