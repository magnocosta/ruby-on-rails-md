# ActiveModel::Attribute-Assignment

Algumas coisas no Rails são bem mágicas e o mais legal é que essas magicas funcionam e funcionam muito bem por sinal. 

Uma curiosidade que eu sempre tive nos objetos do Active Record é o construtor desses objetos. Mágicamente se vocé envia um Hash para esse construtor ele associa cada chave do Hash enviado e popula o atributo de classe que possui o mesmo nome que a chave. Legal né ?!

Vamos dar uma olhada no exemplo:

### user.rb
	# Supondo que essa classe tenha os atributos: 
	# name, password, email
	class User < ActiveRecord::Base
			
	end

### test.rb
	params = {
		name: "Tomas Little",
		email: "tom@gmail.com".
		password: "123455"
	}
	
	user = User.new(params)
	puts user.name # Imprime 'Tomas Little'

## Como ele faz isso?
Pois bem quando usamos o Rails basta ter uma classe que herda de ActiveModel::Base e já ganhamos essa feature. Mas no cógido fonte do Rails existe um módulo que é responsavel em fazer essa tarefa, o nome dele é ActiveModel::AttributeAssignment, como esse módulo está inserido dentro da classe ActiveRecord::Base esse módulo fica disponível implicitamente. 

Para fazer essa tarefa esse módulo tem um método que analisa um Hash e para cada chave do hash ele verifica se a instancia no qual ele está inserido responde á "#{key}=" (que no Ruby significa o método "set" ou o método write), caso a instancia responda ele vai utilizar esse método para setar o valor da sua variável de instancia.

Vamos dar uma olhada no exemplo:

### user.rb
	# Supondo que essa classe tenha os atributos: 
	# name, password, email
	class User < ActiveRecord::Base

	end

### test.rb
	params = {
		name: "Tomas Little",
		email: "tom@gmail.com".
		password: "123455",
		address: "Street 10, Rio de Janeiro"
	}
	
	user = User.new(params)
	puts user.name # Imprime 'Tomas Little'
	
Nesse caso adicionamos uma nova chave (address) no Hash que enviamos para a instancia, porém essa instancia não responde ao método "address=" por que esse atributo não existe no modelo, então o AttributeAssignment ignora esse valor do Hash e segue a vida normalmente.

Uma observação importante é que como ele usa o método "set" do objeto não perdemos o encapsulamento, caso seja necessário adicionar alguma regra no set desse objeto basta escrever o método set e tudo continua funcionando.

## Permited?

Existe uma validação que o ActiveModel::AttributeAssignment pede para um outro componente fazer, que é a verificação se o hash é permitido. Essa validação é realizada por questões de segurança e ela só é realizada se o objeto que você passou para o construtor responde ao método "permit?", como no exemplo anterior usamos a implementação default de Hash essa validacão não é realizada. Tá mas quando que é usado isso?

Quando estamos trabalhando com o Rails é comum pegar os atributos da view e enviar para o modelo (como no exemplo anterior). A diferença aqui é que quando pegamos os atributos da view nós não estamos ultilizando o objeto Hash do Ruby (ele se comporta como um Hash) nesse caso esse objeto responde ao método "permit?", com isso o módulo executa essa validaçao. caso essa validação falhe uma exception é lançada.

Por isso que quando recebemos os parametros da view precisamos adicionar uma linha que permit quais os parametros estão autorizados.

Segue abaixo um exemplo de controller com permit


### users_controller.rb
	class UsersController

		def create
			User.new(params) # Exception é lançada, pois a validação é executada pq não foi permitido os parametros da view
			User.new(my_params) # Tudo funciona perfeitamente, pois o método my_params permit os parametros
		end

		private
		def my_params
			params.permit(:name, :email, :password)
		end
	
	end
