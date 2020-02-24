require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効なファクトリを持っていること" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "姓、名、メール、パスワードがあれば有効な状態であること" do
    user = User.new(
      first_name: "山田",
      last_name: "太郎",
      email: "test@email.com",
      password: "dottle-nouveau-pavilion-tights-furze"
    )
    expect(user).to be_valid
  end

  it "名がなければ無効な状態であること" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "姓がなければ無効な状態であること" do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "メールアドレスがなければ無効な状態であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "ユーザーのフルネームを文字列として返すこと" do
    user = FactoryBot.build(:user, first_name: "Taro", last_name: "Yamada")
    expect(user.name).to eq "Taro Yamada"
  end

  it "重複したメールアドレスなら無効な状態であること" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")

  end
end
