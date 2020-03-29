require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  let(:user) { FactoryBot.create(:user) }


  scenario "ユーザーは新しいプロジェクトを作成する" do

    sign_in user
    go_to_project "New Project"

    expect {
      create_project
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "ユーザーはプロジェクトを完了済みにする" do
    project = FactoryBot.create(:project, owner: user)
    sign_in user

    visit project_path(project)
    expect(page).to_not have_content "Completed"
    click_button "Complete"

    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end

  scenario "完了ずみのプロジェクトはプロジェクト一覧に表示されない" do
    project_doing = FactoryBot.create(:project, name: "Project Doing", owner: user)
    project_done = FactoryBot.create(:project, name: "Completed Project", owner: user, completed: true)
    sign_in user

    visit root_path
    expect(page).to_not have_content "Completed Project"
  end

  scenario "「完了済みのプロジェクト」ボタンをクリックすると、完了済みのプロジェクトが見える" do
    project_doing = FactoryBot.create(:project, name: "Project Doing", owner: user)
    project_done = FactoryBot.create(:project, name: "Completed Project", owner: user, completed: true)
    sign_in user

    visit root_path
    click_button "See Projects Completed"

    expect(page).to have_content "Completed Project"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def create_project
    fill_in "Name", with: "Test Project"
    fill_in "Description", with: "Trying out Capybara"
    click_button "Create Project"
  end
  
  # 失敗をテストするために書かれたテスト
  # scenario "ゲストがプロジェクトを追加する" do
  #   visit projects_path
  #   save_and_open_page
  #   click_link "New Project"
  # end
end
