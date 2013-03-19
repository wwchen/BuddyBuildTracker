class User < ActiveRecord::Base
  has_and_belongs_to_many :emails
  #has_and_belongs_to_many :roles
  has_many :tester_bugs,    :class_name => 'Bug', :foreign_key => 'tester_id'
  has_many :requestor_bugs, :class_name => 'Bug', :foreign_key => 'requestor_id'

  attr_accessible :email, :name, :role, :alias

  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  after_validation :fill_alias

  def to_param
    self.alias
  end

  def fill_alias
    if self.alias.nil? and not self.email.nil?
      self.alias = (self.email.match /(.*)@/)[1]
    end
  end

  def bugs
    [self.tester_bugs + self.requestor_bugs].flatten
  end
end
