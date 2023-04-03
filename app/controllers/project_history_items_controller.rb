class ProjectHistoryItemsController < ApplicationController
  def create_user_comment
    @project = Project.find(params[:project_id])

    @project_history_item = @project.add_user_comment(current_user, user_comment_params[:content])

    respond_to do |format|
      if @project_history_item.persisted?
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'project_history_item_form',
            partial: 'project_history_items/user_comment_form',
            locals: { project_history_item: ProjectHistoryItem.new }
          )
        end

        format.html do
          render(
            partial: 'project_history_items/user_comment_form',
            locals: { project_history_item: ProjectHistoryItem.new }
          )
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'project_history_item_form',
            partial: 'project_history_items/user_comment_form',
            locals: { project_history_item: @project_history_item }
          )
        end

        format.html do
          render(
            partial: 'project_history_items/user_comment_form',
            locals: { project_history_item: @project_history_item },
            status: :unprocessable_entity
          )
        end
      end
    end
  end

  private

  def user_comment_params
    params.require(:project_history_item).permit(:content)
  end
end
