module SecondPartModule
  def second_part
    select "その他", from: "user[user_parts_attributes][1][part_id]"
    fill_in("user[user_parts_attributes][1][other_part]", with: "バイオリン")
    select "初心者", from: "user[user_parts_attributes][1][level]"
  end
end
