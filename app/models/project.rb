# frozen_string_literal: true

# internal projects for the company
class Project < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :owner, class_name: 'User'

  has_many :project_history_items, dependent: :destroy

  validates :name, presence: true

  state_machine :status, initial: :new do
    state :new
    state :in_progress
    state :suspended
    state :completed
    state :cancelled

    event :start do
      transition new: :in_progress
    end

    event :suspend do
      transition in_progress: :suspended
    end

    event :resume do
      transition suspended: :in_progress
    end

    event :cancel do
      transition [:new, :in_progress, :suspended] => :cancelled
    end

    event :complete do
      transition in_progress: :completed
    end

    after_transition any => any do |project, transition|
      project.project_history_items.create!(
        item_type: 'status_change',
        source: 'system',
        content: "Status changed to #{transition.to}"
      )

      project.broadcast_status_change
    end
  end

  def add_user_comment(user, content)
    project_history_items.create(
      item_type: 'user_comment',
      user:,
      source: user.name,
      content:
    )
  end

  def broadcast_status_change
    broadcast_replace_to self
  end
end
