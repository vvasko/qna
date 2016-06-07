class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer  :votable_id
      t.string :votable_type
      t.integer :value

      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.index [:votable_type, :votable_id]
    end


  end
end
