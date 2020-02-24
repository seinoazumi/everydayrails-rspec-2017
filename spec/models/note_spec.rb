require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
  end

  it "ファクトリで関連するデータを生成する" do
    note = FactoryBot.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note's user is #{note.user.inspect}"
  end
 
  it "ユーザー、プロジェクト、noteがあれば有効な状態であること" do

    note = Note.new(
      message: "This is the first note.",
      user: @user,
      project: @project
    )

    expect(note).to be_valid
  end

  it "メッセージがなければ無効な状態であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "文字列に一致するメッセージを検索する" do
    before do
      @note1 = @project.notes.create(
        message: "This is the first note.",
        user: @user
      )

      @note2 = @project.notes.create(
        message: "This is the second note.",
        user: @user
      )

      @note3 = @project.notes.create(
        message: "First, preheat the oven.",
        user: @user
      )
    end

    context "一致するデータが見つかる時" do
      it "検索文字列に一致するnoteを返すこと" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    context "一致するデータが見つかる時" do
      it "空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
