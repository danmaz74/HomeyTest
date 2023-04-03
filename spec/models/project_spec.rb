require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create :project }

  describe '#add_user_comment' do
    let(:user) { create :user }
    let(:content) { 'My comment' }

    let(:last_history_item) { project.project_history_items.order(:created_at).last }

    it 'creates an item with the comment' do
      expect { project.add_user_comment(user, content) }
        .to change { project.project_history_items.count }.by(1)

      expect(last_history_item.item_type).to eq('user_comment')
      expect(last_history_item.user).to eq(user)
      expect(last_history_item.source).to eq(user.name)
      expect(last_history_item.content).to eq(content)
    end

    context 'when the comment is empty' do
      let(:content) { '' }

      it 'does not create an item' do
        expect { project.add_user_comment(user, content) }
          .not_to change { project.project_history_items.count }
      end
    end
  end

  describe 'state machine' do
    let(:last_history_item) { project.project_history_items.order(:created_at).last }

    context 'when there is a transition' do
      it 'creates a history item' do
        expect { project.start }
          .to change { project.project_history_items.count }.by(1)

        expect(last_history_item.item_type).to eq('status_change')
        expect(last_history_item.content).to eq('Status changed to in_progress')
        expect(last_history_item.source).to eq('system')
        expect(last_history_item.user).to be_nil
      end
    end
  end
end
