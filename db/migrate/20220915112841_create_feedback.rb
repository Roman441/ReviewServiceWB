class CreateFeedback < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.integer :card_id, index: true
      t.foreign_key :cards, columns: :card_id
      t.string  :id_feedback, null: false
      t.string  :crt_date, null: false
      t.integer :user_id, null: false
      t.string  :user_name
      t.string  :user_country
      t.string  :text
      t.integer :product_valuation, null: false
    end
  end
end
