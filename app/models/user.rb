# frozen_string_literal: true

# users of this application
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, foreign_key: :owner_id
  has_many :project_history_items # assume that comments shouldn't be destroyed when a user is deleted, not to lose history
end
