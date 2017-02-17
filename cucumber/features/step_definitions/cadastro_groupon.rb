Dado(/^que eu acesse a página de cadastro do Groupon$/) do
  visit '/'
end

Quando(/^eu preencher os campos obrigatório$/) do
  cadastro = Cadastro.new
  cadastro.titulo.select("Sr.")
  cadastro.primero_nome_cliente.set(@first_name)
  cadastro.ultimo_nome_cliente.set(@last_name)
  cadastro.cpf_cliente.set(@cpf)
  cadastro.rua.set("Rua Girassol")
  cadastro.numero_casa.set(@numero_casa)
  cadastro.cep.set(@cep)
  cadastro.cidade.set("São Paulo")
  cadastro.email.set(@email)
  cadastro.telefone.set(@telefone)
  cadastro.senha.set(@senha)
  cadastro.confirma_senha.set(@senha)
  execute_script "jQuery('#terms-checkbox').click();"
end

E(/^enviar$/) do
  click_button 'Cadastro'
end

Então(/^o cadastro deverá ser realizado com sucesso$/) do
  expect(page).to have_content 'O que você procura?'
end
