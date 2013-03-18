class CreateEmailsUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :emails_users, :id => false do |t|
      t.references :email
      t.references :user
    end

    add_index :emails_users, [:email_id, :user_id]
    add_index :emails_users, [:user_id, :email_id]
  end
end
