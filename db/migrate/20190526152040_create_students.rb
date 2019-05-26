class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.integer :university_id
      t.text :name
      t.datetime :started_at

      t.timestamps
    end
  end
end
