module ThirdPartModule
  def third_part
    select "その他", from: "user[user_parts_attributes][2][part_id]"
    fill_in("user[user_parts_attributes][2][other_part]", with: "クラリネット")
    select "初心者", from: "user[user_parts_attributes][2][level]"
  end
end
