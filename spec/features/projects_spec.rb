require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  let(:user) { FactoryBot.create(:user) }

  scenario "ユーザーは新しいプロジェクトを作成する" do

    sign_in user
    visit root_path

    expect(page).to have_content "New Project"
    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failurs do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  # 失敗をテストするために書かれたテスト
  # scenario "ゲストがプロジェクトを追加する" do
  #   visit projects_path
  #   save_and_open_page
  #   click_link "New Project"
  # end
end
