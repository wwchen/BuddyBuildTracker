class Email < ActiveRecord::Base
  has_and_belongs_to_many :users

  serialize :from, Array
  serialize :to, Array
  serialize :cc, Array
  attr_accessible :body, :from, :raw_body, :status, :subject, :to, :cc, :date
end
