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



  # it "guest adds a project" do
  #   visit projects_path
  #   # save_and_open_page
  #   click_link "New Project"
  # end
end
