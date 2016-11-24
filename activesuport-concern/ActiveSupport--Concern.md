# ActiveSupport::Concern

No Ruby existe um recurso muito interessante que é definir alguns métodos e atributos em um arquivo e posteriormente você pode inserir esse arquivo em uma classe ou módulo. Ao fazer isso o módulo ou classe onde você inseriu ganha todos os métodos e atributos. Vamos dar uma olhada no exemplo abaixo:

## Car.rb
	module A

	end

## Car.rb
	module B

	end

## Test.rb
	class C
  		include A
  		include B
	end


Se você já usou o conceito de concern no rails provavelmente você já viu um linha com o código abaixo:
