require 'rails_helper'

RSpec.describe Project, type: :model do

  let(:user) { FactoryBot.create(:user) }

  it "ユーザー単位では重複したプロジェクトを許可しないこと" do

    user.projects.create(
      name: "test project"
    )

    new_project = user.projects.build(
      name: "test project"
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end
  
  it "2人のユーザーが同じ名前を使うのは許可すること" do

    user.projects.create(
      name: "test project"
    )

    other_user = User.create(
      first_name: "Tanaka",
      last_name: "Hanako",
      email: "other@example.com",
      password: "dottle-nouveau-pavilion-tights-furze"
    )

    other_project = other_user.projects.create(
      name: "test project"
    )

    expect(other_project).to be_valid

  end

  it "名前がないとエラーになること" do

    project = user.projects.create(
      name: ""
    )

    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  describe "遅延ステータス" do
    it "締切日を過ぎていたら遅延していること" do
      project = FactoryBot.create(:project_due_yesterday)
      expect(project).to be_late
    end

    it "締切日が今日ならスケジュール通りであること" do
      project = FactoryBot.create(:project_due_today)
      expect(project).not_to be_late
    end

    it "締切日が未来の日付ならスケジュール通りであること" do
      project = FactoryBot.create(:project_due_tomorrow)
      expect(project).not_to be_late
    end
  end

  describe "遅延ステータス(trait)" do
    it "締切日を過ぎていたら遅延していること" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "締切日が今日ならスケジュール通りであること" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).not_to be_late
    end

    it "締切日が未来の日付ならスケジュール通りであること" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).not_to be_late
    end
  end

  it "たくさんのnoteを持っていること" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
