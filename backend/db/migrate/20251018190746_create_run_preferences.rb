class CreateRunPreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :run_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :city
      t.integer :duration
      t.string :skin_type

      t.timestamps
    end
  end
end
