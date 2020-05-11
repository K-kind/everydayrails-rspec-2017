require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { FactoryBot.create(:user) }
  describe "create" do
    context "as an authenticated user" do
      context "with valid attributes" do
        it "adds a project" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in user
          expect {
            post projects_path, params: { project: project_params }
          }.to change(user.projects, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "does not add a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in user
          expect {
            post projects_path, params: { project: project_params }
          }.to_not change(user.projects, :count)
        end
      end
    end
  end

  describe "complete" do
    let(:project) { FactoryBot.create(:project, owner: user, completed: false) }
    let(:other_user) { FactoryBot.create(:user) }

    context "as an authenticated user" do
      before do
        sign_in user
      end

      it "completes a project" do
        patch complete_project_path(project)
        expect(project.reload).to be_completed
      end

      describe "an unsuccessful completion" do
        before do # 更新を失敗させる
          allow_any_instance_of(Project).
            to receive(:update_attributes).
            with(completed: true).
            and_return(false)
        end

        it "redirects to the project page" do
          patch complete_project_path(project)
          expect(response).to redirect_to project_path(project)
        end
        
        # it "sets the flash" do
        #   # patch complete_project_path(project)
        #   # expect(flash[:alert]).to eq "Unable to complete project."
        # end

        it "does not mark the project as completed" do
          expect {
            patch complete_project_path(project)
          }.to_not change(project, :completed)
        end
      end
    end

    context "as an unauthenticated user" do
      it "does not complete a project" do
        sign_in other_user
        expect {
          patch complete_project_path(project)
        }.to_not change(project, :completed)
      end
    end
  end
end
