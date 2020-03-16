require 'rails_helper'

RSpec.feature "notes", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: "Feature Note Spec", owner: user) }
  let!(:note) { project.notes.create!(user: user, message: "Test Note") }

  scenario "ユーザーはノートを作成できる" do
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      click_link "Feature Note Spec"
      click_link "Add Note"
      fill_in "Message", with: "Test Note"
      click_button "Create Note"

      expect(page).to have_content "Note was successfully created"
      expect(page).to have_content "Test Note"
    }.to change(project.notes, :count).by(1)
  end
end
