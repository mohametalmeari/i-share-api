class AddUserRefToReposts < ActiveRecord::Migration[7.0]
  def change
    add_reference :reposts, :user, null: false, foreign_key: true
  end
end
