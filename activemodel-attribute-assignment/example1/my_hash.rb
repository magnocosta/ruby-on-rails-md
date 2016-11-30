class MyHash < Hash

  def permitted?
    false
  end

  def stringify_keys
    dup
  end

end
