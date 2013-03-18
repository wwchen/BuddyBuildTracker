class AssociateEmailToUser < ActiveRecord::Migration
  def change
    change_table :emails do |t|
      t.references :user
    end
  end
end
