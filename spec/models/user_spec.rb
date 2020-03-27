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

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it "重複したメールアドレスなら無効な状態であること" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "アカウントが作成された時にウェルカムメールを送信すること" do
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it "ジオコーディングを実行すること", vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).from(nil).to("Brooklyn, New York, US")
  end
end
