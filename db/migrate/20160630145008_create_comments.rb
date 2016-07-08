class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id, index: true
      t.string :commentable_type, index: true
      t.integer :user_id, index: true
      t.timestamps null: false
    end
  end
end
