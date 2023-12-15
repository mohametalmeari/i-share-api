class CreateReposts < ActiveRecord::Migration[7.0]
  def change
    create_table :reposts do |t|

      t.timestamps
    end
  end
end
