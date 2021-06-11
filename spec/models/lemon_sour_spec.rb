require 'rails_helper'

RSpec.describe LemonSour, type: :model do
  it "商品名があれば有効" do
    named_lemon_sour = LemonSour.new(name: "氷結")
    expect(named_lemon_sour).to be_valid
  end
  it "商品名が無ければ無効" do
    noname_lemon_sour = LemonSour.new(name: "")
    expect(noname_lemon_sour).to_not be_valid
  end
end
