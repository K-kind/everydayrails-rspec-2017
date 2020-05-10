class Api::TasksController < ApplicationController
  prepend_before_action :authenticate_user_from_token!

  def index
    # debugger
    @tasks = @project.tasks
    render json: @tasks
  end

  def show
    @project = Project.find(params[:id])
    render json: @project
  end

  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      render json: { status: :created }
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user = user_email && User.find_by(email: user_email)
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: true
      unless @project = user.projects.find_by_id(params[:project_id])
        render json: { status: "invalid user" }, status: "401"
        false
      end
      # debugger
    else
      render json: { status: "auth failed" }
      false
    end
    # debugger
  end

  # def reject_other_user!
  #   # debugger
  #   return unless @current_user

  #   unless @project = @current_user.projects.find_by_id(params[:project_id])
  #     render json: { status: "invalid user" }, status: "401"
  #     false
  #   end
  # end

  def project_params
    params.require(:project).permit(:name, :description, :due_on)
  end
end
