class User < ActiveRecord::Base
  has_and_belongs_to_many :emails
  #has_and_belongs_to_many :roles
  has_many :tester_bugs,    :class_name => 'Bug', :foreign_key => 'tester_id'
  has_many :requestor_bugs, :class_name => 'Bug', :foreign_key => 'requestor_id'

  def bugs
    [self.tester_bugs + self.requestor_bugs].flatten
  end

  attr_accessible :email, :name, :role
end
