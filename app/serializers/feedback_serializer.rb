class FeedbackSerializer < ActiveModel::Serializer
  attributes :date_create, :user_name, :user_country, :product_valuation, :feedback_text, :id_feedback

  def date_create
    object.crt_date
  end

  def feedback_text
    object.text
  end

  #belongs_to :card
  #def cards
  # object.cards.where(: )
  #end
end
