class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.integer :tfs_id
      t.string  :status
      t.string  :drop_folder
      t.references :requestor
      t.references :tester

      t.timestamps
    end
  end
end
