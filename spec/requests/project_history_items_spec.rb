require 'rails_helper'

RSpec.describe "ProjectHistoryItems", type: :request do
  describe "POST #create_user_comment" do
    let(:project) { create :project }
    let(:user) { create :user }

    before do
      login_as(user, scope: :user)
    end

    let(:content) { Faker::Lorem.paragraph }

    let(:last_history_item) { project.project_history_items.order(:created_at).last }

    subject(:post_create_user_comment) do
      post create_user_comment_project_project_history_items_path(project),
           params: { project_history_item: { content: content } }
    end

    it 'creates an item with the comment' do
      expect { post_create_user_comment }
        .to change { project.project_history_items.count }.by(1)

      expect(response).to have_http_status(:success)

      expect(last_history_item.item_type).to eq('user_comment')
      expect(last_history_item.user).to eq(user)
      expect(last_history_item.source).to eq(user.name)
      expect(last_history_item.content).to eq(content)
    end

    context 'when the comment is empty' do
      let(:content) { '' }

      it 'does not create an item' do
        expect { post_create_user_comment }
          .not_to change { project.project_history_items.count }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the user is not logged in' do
      before do
        logout(:user)
      end

      it 'does not create an item' do
        expect { post_create_user_comment }
          .not_to change { project.project_history_items.count }

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
