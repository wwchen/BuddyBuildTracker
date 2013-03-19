class Bug < ActiveRecord::Base
  belongs_to :requestor, :class_name => "User"
  belongs_to :tester,    :class_name => "User"

  attr_accessible :tfs_id, :status, :drop_folder, :requestor, :tester
  validates :tfs_id,        :presence => true
  validate :requestor_role, :unless => "requestor_id.nil?"
  validate :tester_role,    :unless => "tester_id.nil?"

  def requestor_role
    requestor.role != 'developer' && errors.add(:requestor, "not a developer")
  end

  def tester_role
    tester.role != 'tester' && errors.add(:tester, "not a tester")
  end
end
