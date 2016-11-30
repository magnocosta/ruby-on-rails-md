class MyObject
  include ActiveModel::AttributeAssignment
  attr_accessor :name, :path, :date

  def initialize(attributes={})
    assign_attributes attributes    
  end

end
