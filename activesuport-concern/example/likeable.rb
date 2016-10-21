module Likeable

  def self.included(base)
    puts "included classMethod module #{base}"
    base.extend ClassMethods
    base.class_eval do
      def hello
        puts "Hello"
      end

      def yop
        puts "yop"
      end
    end
  end

  def like
    puts "Add Like"
  end

  module ClassMethods
    
    def find_with_like
      puts "Found: 30 itens"
    end

  end

end
