class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :notes
  has_many :tasks

  scope :completed_or_not, ->(completed = nil) {
    if completed == 1
      where(completed: true)
    else
      # where('completed = ? or completed = ?', nil, false)
      where(completed: false).or(where(completed: nil))
    end
  }

  def late?
    due_on.in_time_zone < Date.current.in_time_zone
  end
end
