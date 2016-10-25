# ActiveSupport::Concern

No Ruby existe um recurso muito interessante que é definir alguns métodos e atributos em um arquivo e posteriormente você pode inserir esse arquivo em uma classe ou módulo. Ao fazer isso o módulo ou classe onde você inseriu ganha todos os métodos e atributos do arquivo inserido. 

Vamos dar uma olhada no exemplo abaixo:

### commentable.rb
	module Commentable
			
		def comment(msg)
			puts "Comment #{msg}"
		end

	end

### likeable.rb
	module Likeable
		
		def like
			puts "Like"
		end

	end

### post.rb
	class Post
  		include Likeable
  		include Commentable
	end

## Exemplo:
	post = Post.new
	post.like
	post.comment "Hello"


Todos os métodos criados até aqui são métodos de instancia e se precisarmos criar métodos de classe dentro do módulo de modo que esse método fique disponível na classe Post?

### likeable.rb
	module Likeable

		def like
			puts "Like"
		end
		
		def self.find_with_like
			puts "Found: 30 itens"
		end
		
	end

## Exemplo:
	Likeable.find_with_like # ok
	Post.find_with_like # not ok


Do modo descrito acima não funciona pois o método `find_with_like` é adicionado como método de classe apenas no módulo Likeable. Para ele ser inserido dinamicamente em todas as classes que injetam o módulo likeable precisariamos de algo assim:


### likeable.rb
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
## Exemplo
	Likeable.find_with_like # not ok
	Post.find_with_like # ok
	

## O Problema
Até aqui só vimos cógido Ruby e tudo funciona sem problmas, nesse contexto o ActiveSuport::Concern é util apenas para economizar algumas linhas de código mas nem são tantas assim, claro já ajuda. 

A principal motivação para a criação do ActiveSuport::Concern (Acredito eu) é que nativamento o Ruby não resolve dependencia entre módulos. O que acontece é que quando temos um módulo que depende de outro módulo nós precisamos incluir o módulo que queremos e todas as suas dependencias na classe "hospedeira" se não fizermos isso o classe base que é passada para o módulo inserido é o módulo que inclui os outros módulos e não a classe hospedeira. Complexo? um pouco, vamos ver o exemplo abaixo.

Seguindo o exemplo anterior imagine que queremos organizar os "conceitos" likeable e commentable em apenas um unico módulo chamado "Social" teriamos então o seguinte codigo abaixo:


### Social.rb

	module Social
		indlude Commentable
		include Likeable
	end

### Post.rb

	module Post
		include Social
	end
	

## Exemplo
	Post.find_with_like # not ok
	Social.find_with_like # ok
	

## O que aconteceu?
O que aconteceu é que como referenciamos os módulos Commentable e Likeable apenas dentro do módulo Social o Ruby entende que Social é a base e é nela que os métodos dinamicos devem ser criados. Como se resolve isso com o Ruby? 

Criando uma classe Post como está escrito abaixo:

### Post.rb

	module Post
		include Likeable
		include Commentable
		include Social
	end


O problema dessa abordagem é que acaba-se perdendo o encapsulamento e você precisa conhecer e colocar na classe hospedeira todos os módulos que você precisa e as suas dependências.

E é nesse caso que o módulo ActiveSuport::Concern mais vai ser útil. Esse módulo consegue identificar as depêndencias e enviar a classe correta (no caso a classe hospedeira) para os módulos injetados dentro de outros módulos. 

Para isso o time do rails criou uma DSL que é bem simples de usar o que torna bem fácil a utilização.

Segue abaixo o mesmo exemplo acima utiliando o ActiveSuport::Concern.

### commentable.rb
	module Commentable
			
		def comment(msg)
			puts "Comment #{msg}"
		end

	end

### likeable.rb
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
	 
### post.rb
	class Social
		extend ActiveSupport::Concern
		include Commentable
		include Likeable
	end

### post.rb
	class Post
		include Social
	end

## Explicando

Bom não sei se ficou claro mas de qualquer forma vou explicar para exclarecer as dúvidas.

Na classe Likeable como usamos os métodos do ActiveSupport::Concern (included e class_methods) vamos precisar adicionar extend ActiveSupport::Concern.

incldued -> Adiciona métodos de instancia.
class_methods -> Adiciona métodos de classe.

Na classe Commentable não usamos nada do ActiveSupport::Concern então não muda nada.

Na classe Social incluímos Commentable e Likeable e a ActiveSupport::Concern pois precisamos do recurso do ActiveSupport::Concern para resolver as dependencias de maneira correta (Por default o Ruby não reslove isso, como eu já citei anteriormente).


Na classe Post só usamos Social então não precisa de mais nada também.

Com a utilização do ActiveSupport::Concern a reutilização de métodos fica muito mais fácil. Estou lendo o código fonte do Rails e essa abordagem é ultilizada em várias partes, na minha opinião foi uma idéia muito boa que o Core Team teve ao criar esse módulo e o mais legal podemos utilizá-lo sempre que precisarmos, Se estivermos trabalhando em um projeto Rails basta utilizar conforme eu usei. Caso contrário é só utilizar a gem activesupport que você já ganha esse recurso de brinde.

Caso tenha interesse em saber como ela foi implementada segue o [link](https://github.com/magnocosta/rails/blob/master/activesupport/lib/active_support/concern.rb):


Espero que tenha ajudado em algo. =)
