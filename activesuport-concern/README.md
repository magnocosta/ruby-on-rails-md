# ActiveSupport::Concern

No Ruby existe um recurso muito interessante que é definir alguns métodos e atributos em um arquivo e posteriormente você pode inserir esse arquivo em uma classe ou módulo. Ao fazer isso o módulo ou classe onde você inseriu ganha todos os métodos e atributos do arquivo inserido. 

Vamos dar uma olhada no exemplo abaixo:

## Commentable.rb
	module Commentable
			
		def comment(msg)
			puts "Comment #{msg}"
		end

	end

## Likeable.rb
	module Likeable
		
		def like
			puts "Like"
		end

	end

## Post.rb
	class Post
  		include Likeable
  		include Commentable
	end

## Utilizando
	post = Post.new
	post.like
	post.comment "Hello"


Todos os métodos criados até aqui são métodos de instancia e se precisarmos criar métodos de classe dentro do módulo de modo que esse método fique disponível na classe Post?

## likeable.rb
	module Likeable

		def like
			puts "Like"
		end
		
		def self.find_with_like
			puts "Found: 30 itens"
		end
		
	end

## Utilizando
	Likeable.find_with_like # ok
	Post.find_with_like # not ok


Do modo descrito acima não funciona pois o método `find_with_like` é adicionado como método de classe apenas no módulo Likeable. Para ele ser inserido dinamicamente em todas as classes que injetam o módulo likeable precisariamos de algo assim:


## likeable.rb
	module Likeable
		
		def self.included(base)
			base.extend ClassMethods
		end

		def like
			puts "Like"
		end
		
		module ClassMethods
			def find_with_like
				puts "Found: 30 itens"
			end
		end
		
	end