module Likeable
  extend ActiveSupport::Concern

  included do

    def hello
      puts "Hello"
    end

    def yop
      puts "yop"
    end
  end

  class_methods do

    def find_with_like
      puts "Found: 30 itens"
    end
  end

end
