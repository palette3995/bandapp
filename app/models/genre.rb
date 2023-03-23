class Genre < ActiveHash::Base
  include ActiveHash::Associations

  has_many :user_genres, dependent: :destroy
  has_many :band_genres, dependent: :destroy

  def users
    user_genres.map(&:user)
  end

  def bands
    band_genres.map(&:band)
  end

  self.data = [
    { id: 1, name: "J-POP" }, { id: 2, name: "アニメ" }, { id: 3, name: "邦楽ヒップホップ/R&B/レゲエ" },
    { id: 4, name: "邦楽ロック" }, { id: 5, name: "邦楽ダンス/エレクトロニカ" }, { id: 6, name: "ボーカロイド" },
    { id: 7, name: "K-POP/ワールド・ミュージック" }, { id: 8, name: "洋楽ポップス" }, { id: 9, name: "洋楽ヒップホップ/R&B/レゲエ" },
    { id: 10, name: "洋楽ロック" }, { id: 11, name: "洋楽ダンス/エレクトロニカ" }, { id: 12, name: "歌謡曲/演歌" },
    { id: 13, name: "ジャズ" }, { id: 14, name: "クラシック" }, { id: 15, name: "その他" },
    { id: 16, name: "未選択" }
  ]
end
