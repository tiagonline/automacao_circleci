Before '@general_stuffs' do
  @senha = Faker::Base.numerify('inicial####').to_s
  @telefone = Faker::Base.numerify('9####-####').to_s
  @email = Faker::Internet.email
  @cep = Faker::Base.numerify('05433-00#').to_s
  @numero_casa = Faker::Base.numerify('####').to_s
  @cpf = Faker::CPF.numeric
  @last_name = Faker::Name.last_name
  @first_name = Faker::Name.first_name
end
