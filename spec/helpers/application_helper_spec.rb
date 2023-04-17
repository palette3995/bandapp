require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#full_title(page_title)" do
    context "page_titleが空白の場合" do
      it "ページのタイトルが GROUVE になること" do
        expect(full_title("")).to eq("GROUVE")
      end
    end

    context "page_titleがnilの場合" do
      it "ページのタイトルが GROUVE になること" do
        expect(full_title(nil)).to eq("GROUVE")
      end
    end

    context "page_titleが存在する場合" do
      it "ページのタイトルが page_title - GROUVE になること" do
        expect(full_title("sample")).to eq("sample - GROUVE")
      end
    end
  end
end
