class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def status_transition
    @project = Project.find(params[:id])

    return head(:forbidden) unless @project.owner == current_user
    return head(:bad_request) unless @project.status_transitions.map(&:event).include?(params[:event].to_sym)

    if @project.send("#{params[:event]}!")
      redirect_to @project, notice: 'Project status was successfully updated.'
    else
      redirect_to @project, alert: 'Project status could not be updated.'
    end
  end

  def show
    @project = Project.find(params[:id])

    @is_owner = @project.owner == current_user
    @available_transition_events = @project.status_transitions.map(&:event)
  end

  private

  def project_params
    params.require(:project).permit(:status)
  end
end
