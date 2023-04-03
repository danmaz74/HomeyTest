# frozen_string_literal: true

# could be user comments or changes in status
class ProjectHistoryItem < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :project
  belongs_to :user, optional: true

  ITEM_TYPES = %w[user_comment status_change].freeze

  validates_presence_of :content
  validates_presence_of :source
  validates_inclusion_of :item_type, in: ITEM_TYPES

  after_create_commit { broadcast_prepend_to [project, :project_history_items], target: "#{dom_id(project)}_project_history_items" }
end
