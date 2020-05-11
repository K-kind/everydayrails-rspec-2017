require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it "user creates a new project" do
    # sign_in_as(user)
    sign_in user
    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
  
  it "user update a project" do
    project = FactoryBot.create(:project, owner: user)
    sign_in user
    visit root_path
    
    click_link project.name
    find("a[href=\"#{edit_project_path(project)}\"]").click
    # within ".heading" do
    #   cilck_link "Edit"
    # end
    
    fill_in "Name", with: "Updated project name"
    fill_in "Description", with: "Updated project description"
    select "2024", from: "project_due_on_1i"
    select "May", from: "project_due_on_2i"
    select "18", from: "project_due_on_3i"
    click_button "Update Project"
    
    aggregate_failures do
      expect(project.reload.name).to eq "Updated project name"
      expect(page).to have_content "Project was successfully updated"
      expect(page).to have_content "Updated project name"
      expect(page).to have_content "Updated project description"
      expect(page).to have_content "May 18, 2024"
    end
  end

  it "user completes a project" do
    # プロジェクトを持ったユーザーを準備
    project = FactoryBot.create(:project, name: "Project to be completed", owner: user)
    # ユーザーはログインしている
    sign_in user
    # プロジェクト詳細画面でcompleteボタンを押す
    visit project_path(project)
    click_button "Complete"
    # プロジェクトは完了済みとしてマークされる
    aggregate_failures do
      expect(project.reload.completed?).to be true
      expect(page).to \
        have_content "Congratulations, this project is complete!"
      expect(page).to have_content "Completed"
      expect(page).to_not have_button "Complete"
    end
    # ダッシュボードに戻る
    visit root_path
    # 完了済みのプロジェクトは表示されない
    expect(page).to_not have_content "Project to be completed"
  end

  describe "projects on dashboard" do
    before do
      FactoryBot.create(:project, name: "Incompleted project", completed: false, owner: user)
      FactoryBot.create(:project, name: "Completed project1", completed: true, owner: user)
      sign_in user
      visit root_path
    end

    it "only incompleted projects are shown by default" do
      expect(page).to have_content "Incompleted project"
      expect(page).to_not have_content "Completed project1"
    end

    it "projects are toggled by clicking the toggle button" do
      click_link "Completed Projects"
      expect(page).to_not have_content "Incompleted project"
      expect(page).to have_content "Completed project1"

      click_link "Incompleted Projects"
      expect(page).to have_content "Incompleted project"
      expect(page).to_not have_content "Completed project1"
    end
  end
end
