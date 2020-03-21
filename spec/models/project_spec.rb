require 'rails_helper'

RSpec.describe Project, type: :model do

  let(:user) { FactoryBot.create(:user) }

  # ユーザーは同じ名前のプロジェクトを複数持つことができないが、ユーザーが異なれば同じ名前のプロジェクトがあっても構わない、というテスト
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

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
