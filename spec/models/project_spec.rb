require 'rails_helper'

RSpec.describe Project, type: :model do
  it "is invalid without a name" do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include "can't be blank"
  end

  it "does not allow duplicate project names per user" do
    # user = User.create(
    #   first_name: "Joe",
    #   last_name: "Tester",
    #   email: "joetester@example.com",
    #   password: "dottle-nouveau-pavilion-tights-furze",
    # )
    user = FactoryBot.create(:user)
    
    user.projects.create(
      name: "Test Project",
    )

    new_project = user.projects.build(
      name: "Test Project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    # user = User.create(
    #   first_name: "Joe",
    #   last_name: "Tester",
    #   email: "joetester@example.com",
    #   password: "dottle-nouveau-pavilion-tights-furze",
    # )
    user = FactoryBot.create(:user)
    
    user.projects.create(
      name: "Test Project",
    )
    
    # other_user = User.create(
    #   first_name: "Jane",
    #   last_name: "Tester",
    #   email: "janetester@example.com",
    #   password: "dottle-nouveau-pavilion-tights-furze",
    # )
    other_user = FactoryBot.create(:user)

    other_project = other_user.projects.build(
      name: "Test Project",
    )

    expect(other_project).to be_valid
  end

  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  describe "late status" do
    it "is late when the due date is yesterday" do
      project = FactoryBot.create(:project_due_yesterday)
      expect(project).to be_late
    end

    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end
  end
end
