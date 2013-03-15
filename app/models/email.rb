class Email < ActiveRecord::Base
  serialize :from, Array
  serialize :to, Array
  serialize :cc, Array
  attr_accessible :body, :from, :raw_body, :status, :subject, :to, :cc, :date
end
