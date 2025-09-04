class CreateSleepTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :sleep_trackers do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :slept_at, null: false
      t.datetime :woke_up_at
      t.integer :duration, null: true

      t.timestamps
    end

    add_index :sleep_trackers, :slept_at
    add_index :sleep_trackers, :duration
  end
end
