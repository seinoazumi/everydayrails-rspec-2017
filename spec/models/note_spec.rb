require 'rails_helper'

RSpec.describe Note, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it { is_expected.to have_attached_file(:attachment) }

  # このexampleは本の後半で出てこなくなったのでコメントアウト
  # it "ファクトリで関連するデータを生成する" do
  #   note = FactoryBot.create(:note)
  #   puts "This note's project is #{note.project.inspect}"
  #   puts "This note's user is #{note.user.inspect}"
  # end
 
  it "ユーザー、プロジェクト、noteがあれば有効な状態であること" do
    note = Note.new(
      message: "This is the first note.",
      user: user,
      project: project
    )

    expect(note).to be_valid
  end

  it "メッセージがなければ無効な状態であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "文字列に一致するメッセージを検索する" do
    let!(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the first note.",
      )
    }

    let!(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the second note.",
      )
    }

    let!(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven.",
      )
    }

    context "一致するデータが見つかる時" do
      it "検索文字列に一致するnoteを返すこと" do
        expect(Note.search("first")).to include(note1, note3)
      end
    end

    context "一致するデータが見つからない" do
      it "空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end

  it "名前の取得をnoteを作成したユーザーに委譲すること" do
    user = double("User", name: "Fake User")
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end
end
