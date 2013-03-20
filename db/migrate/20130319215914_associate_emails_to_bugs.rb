class AssociateEmailsToBugs < ActiveRecord::Migration
  def up
    change_table :emails do |t|
      t.references :bug
    end
  end
  def down
    change_table :emails do |t|
      t.remove :bug_id
    end
  end
end
