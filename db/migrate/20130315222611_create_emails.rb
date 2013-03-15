class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :cc
      t.datetime :date
      t.string :subject
      t.string :body
      t.string :raw_body
      t.string :status

      t.timestamps
    end
  end
end
