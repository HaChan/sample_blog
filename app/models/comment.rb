class Comment < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :entry_id, presence: true
	validates :content, presence: true, length: { maximum: 300 }
end
