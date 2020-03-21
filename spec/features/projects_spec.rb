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
