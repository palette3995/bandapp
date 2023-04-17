class Part < ActiveHash::Base
  include ActiveHash::Associations

  has_many :user_parts, dependent: :destroy
  has_many :recruit_members, dependent: :destroy
  has_many :scouts, dependent: :destroy
  has_many :band_members, dependent: :destroy

  def users
    user_parts.map(&:user)
  end

  def bands
    recruit_members.map(&:band)
  end

  self.data = [
    { id: 1, name: "ボーカル" }, { id: 2, name: "ギター" }, { id: 3, name: "ベース" },
    { id: 4, name: "ドラム/パーカッション" }, { id: 5, name: "キーボード/ピアノ" }, { id: 6, name: "その他" },
    { id: 7, name: "未選択" }
  ]
end
