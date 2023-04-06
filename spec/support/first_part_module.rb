module FirstPartModule
  def first_part
    select "その他", from: "user[user_parts_attributes][0][part_id]"
    fill_in("user[user_parts_attributes][0][other_part]", with: "フルート")
    select "初心者", from: "user[user_parts_attributes][0][level]"
  end
end
