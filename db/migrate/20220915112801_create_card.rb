class CreateCard < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.bigint :value, null: false, index: true
    end
  end
end
