class AddAliasToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :alias
    end
  end
end
