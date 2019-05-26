class CreateUniversities < ActiveRecord::Migration[5.2]
  def change
    create_table :universities do |t|
      t.integer :api_id
      t.text :name
      t.text :city
      t.text :web_page
      t.text :classification
      t.datetime :founded_at

      t.timestamps
    end
  end
end
