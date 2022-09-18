class Wildberries::CardProduct < ActiveRecord::Base
  self.table_name = :cards
  self.primary_key = :id

  has_many :feedbacks
end
