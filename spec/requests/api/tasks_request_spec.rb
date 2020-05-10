require 'rails_helper'

RSpec.describe "Api::Tasks", type: :request do
  describe "get" do
    it "loads project tasks" do
      user = FactoryBot.create(:user)
      project = FactoryBot.create(:project, owner: user)
      project.tasks.create(name: "Test task1")

      get api_project_tasks_path(project.id), params: {
        user_email: user.email,
        user_token: user.authentication_token,
      }
      json = JSON.parse(response.body)
      expect(json[0]["name"]).to eq("Test task1")
    end
  end
end
