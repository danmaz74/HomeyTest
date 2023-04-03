require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:project_owner) { create(:user) }
  let(:other_user) { create(:user) }

  let(:project) { create(:project, owner: project_owner, status: 'in_progress') }

  describe "GET /show" do
    context 'when the user is the project owner' do
      before do
        login_as(project_owner, scope: :user)

        get project_path(project)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'includes the buttons for the correct status transitions' do
        expect(response.body).to include('status_transition?event=suspend')
        expect(response.body).to include('status_transition?event=cancel')
        expect(response.body).to include('status_transition?event=complete')

        expect(response.body).not_to include('status_transition?event=start')
        expect(response.body).not_to include('status_transition?event=resume')
      end
    end

    context 'when the user is not the project owner' do
      before do
        login_as(other_user, scope: :user)

        get project_path(project)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'does not include any buttons for status transitions' do
        expect(response.body).not_to include('status_transition?event=start')
        expect(response.body).not_to include('status_transition?event=resume')
        expect(response.body).not_to include('status_transition?event=suspend')
        expect(response.body).not_to include('status_transition?event=cancel')
        expect(response.body).not_to include('status_transition?event=complete')
      end
    end

    context 'when the user is not logged in' do
      before do
        get project_path(project)
      end

      it "returns a redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "PATCH /status_transition" do
    let(:transition_event) { 'suspend' }

    subject(:patch_status_transition) do
      patch status_transition_project_path(project, event: transition_event)
    end

    context 'when the user is the project owner' do
      before do
        login_as(project_owner, scope: :user)
      end

      it 'changes the project status' do
        expect { patch_status_transition }
          .to change { project.reload.status }.to('suspended')
      end

      it 'redirects to the project page' do
        patch_status_transition

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(project_path(project))
      end

      context 'when the event is invalid' do
        let(:transition_event) { 'invalid' }

        it 'does not change the project status' do
          expect { patch_status_transition }
            .not_to change { project.reload.status }
        end

        it 'redirects bad_request' do
          patch_status_transition

          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when the user is not the project owner' do
      before do
        login_as(other_user, scope: :user)
      end

      it 'does not change the project status' do
        expect { patch_status_transition }
          .not_to change { project.reload.status }
      end

      it 'returns forbidden error' do
        patch_status_transition

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is not logged in' do
      it 'does not change the project status' do
        expect { patch_status_transition }
          .not_to change { project.reload.status }
      end

      it 'returns a redirect' do
        patch_status_transition

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "GET /index" do
    context 'when a user is logged in' do
      before do
        login_as(project_owner, scope: :user)

        get projects_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the user is not logged in' do
      before do
        get projects_path
      end

      it "returns a redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
