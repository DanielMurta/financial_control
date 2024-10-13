class CreateAccount < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.float :balance, default: 0.0
      t.belongs_to :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
