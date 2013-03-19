class RemoveRoles < ActiveRecord::Migration
  def change
    drop_table :roles
    drop_table :roles_users
    remove_index "roles_users", ["role_id", "user_id"]
    remove_index "roles_users", ["user_id", "role_id"]
    change_table :users do |t|
      t.string :role
    end
  end
end
