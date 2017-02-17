#language: pt

Funcionalidade: Cadastro de usuário no Groupon

Eu, como cliente novo
Desejo realizar um cadastro no portal
Para realizar compras com desconto

@general_stuffs
@gp_cadastro
Cenário: Cadastro com sucesso

  Dado que eu acesse a página de cadastro do Groupon
  Quando eu preencher os campos obrigatório
  E enviar
  Então o cadastro deverá ser realizado com sucesso
