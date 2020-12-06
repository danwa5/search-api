class CreateSearchTerm < ActiveRecord::Migration[6.0]
  def change
    create_table :search_terms do |t|
      t.datetime :block_time, null: false
      t.string :term, null: false
      t.integer :search_count, default: 0
      t.timestamps null: false
    end

    add_index :search_terms, [:block_time, :term], unique: true
  end
end
