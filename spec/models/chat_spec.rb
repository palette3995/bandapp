require "rails_helper"

RSpec.describe Chat do
  let!(:chat) { create(:chat) }

  it "メッセージが500文字以内であれば登録できること" do
    expect(chat).to be_valid
  end

  it "メッセージが501文字以上であれば登録できないこと" do
    chat.message = SecureRandom.alphanumeric(501)
    expect(chat).not_to be_valid
    expect(chat.errors).not_to be_empty
  end
end
