module Likeable
  extend ActiveSupport::Concern

  included do

    def like
      puts "Like"
    end
  end

  class_methods do

    def find_with_like
      puts "Found: 30 itens"
    end
  end

end
