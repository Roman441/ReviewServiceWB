class CardSerializer < ActiveModel::Serializer
  attributes :id
  has_many :feedbacks
end
