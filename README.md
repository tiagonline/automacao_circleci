# Colocando seus testes no CI com Circle CI

Continuos Integration, vulgo CI vem sendo um assunto muito comentado, principalmente em algumas rodas de QAs e logo de cara as pessoas pensam em Jenkins para subir os testes e deixar bonitinho, com relatórios exorbitantes e bonitos pra ganhar aquela moral com o time e claro, pra facilitar o trabalho.

Mas, muitos QAs quando se deparam com o Jenkins e sua dificuldade em configurar e entender os conceitos, acabam construindo muros e então criando o desânimo e deixam de lado essa cultura de OPs que é muito legal.

Com esse intuito, comecei a conversar com alguns amigos meus (devs e devops) sobre o que a galera moderna anda utilizando e vieram com um app chamado [Circle Ci] (https://circleci.com), que na minha opinião, facilitou MUITO o trabalho de subir os testes em uma ferramenta de entrega contínua, e não precisamos perder tempo instalando o Jenkins, configurandos os plugins, bla bla bla de chatice e no caso do circleci, login via github e o mais legal, tudo se resume a apenas um arquivo =).

Com isso, resolvi criar esse repositório para justamente passar essa visão simplista de como subir seus testes em uma ferramenta de CI sem muito custo, sem muitos adicionais rsrsr, de forma rápida e clara. Nesse repositório vou ensinar apenas como colocar os testes lá no circleci para que todo push que você der nos seu repositório possa pegar esses testes e executá-los, pois a idéia do circle é exatamente essa, comitt -> push -> executa.

Bem, nesse repositório, que está escrito em cucumber + capybara, não vou aqui explicar nada sobre cucumber, nada sobre capybara, se quiserem, vejam [capybara for all] (https://github.com/thiagomarquessp/capybaraforall), ou seja, estou considerando que todos aqui conheçam, ou indo além, que tenham seus testes no github. Nesse exemplo, vou colocar os testes que estão em linguagem ruby, MAS, se vocês tiverem seus testes em: Go (Golang), Haskell, Java, Node.js, PHP, Python, Scala o conceito será o mesmo OK.

Só para explicar o repositório em questão OK: Está em cucumber com apenas uma feature chamada Cadastro no Groupon e um arquivo de steps com o mesmo nome, assim como todo o conceito de Page Objects com Site::Prism, etc. No arquivo de feature, tem uma variável que antecede o Cenario de cadastro chamada @gp_cadastro que vamos utilizá-la como TAG para execução do meu teste OK.

Bom, vamos lá ao que interessa:

Se vocês observarem o repositório, temos ai um arquivo na raiz do projeto chamado circle.yml dessa maneira:

```ruby
machine:
 ruby:
   version: ruby-2.2.2
 services:
   - docker
dependencies:
 pre:
   - sudo apt-get install libxss1 libappindicator1 libindicator7
   - wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
   - sudo dpkg -i google-chrome*.deb
   - sudo apt-get install -f
   - sudo apt-get install jq nodejs curl -qy
   - npm install -g geckodriver
   - npm install -g chromedriver@2.25
   - gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
   - curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2
 override:
   - rvm use .
   - gem install bundler
   - bundle install
test:
 override:
   - cd cucumber; cucumber -p chrome -p qa --tags @gp_cadastro
```
onde:

```ruby
machine:
 ruby:
   version: ruby-2.2.2
 services:
   - docker

Basicamente estou falando que eu quero uma máquina (que é instalada via container no docker(services)) com a versão 2.2.2 do ruby (nesse caso é a versão que eu estou utilizando, mas isso é a critério do cliente). Toda vez que meu  teste for executado, ele vai montar uma máquina nova e ao fim do teste, essa máquina morre. Eu posso sair brincando com as configurações, por exemplo colocar timezone de SP:
  timezone:
  America/Sao_Paulo

Só dar uma olhada na documentação do circle (https://circleci.com/docs/)
```

```ruby
dependencies:
 pre:
   - sudo apt-get install libxss1 libappindicator1 libindicator7
   - wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
   - sudo dpkg -i google-chrome*.deb
   - sudo apt-get install -f
   - sudo apt-get install jq nodejs curl -qy
   - npm install -g geckodriver
   - npm install -g chromedriver@2.25
   - gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
   - curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2
 override:
   - rvm use .
   - gem install bundler
   - bundle install

Essa é a parte interessante de ter um arquivo para configurar tudo do seu jeito, por exemplo, no meu ecossistema, eu utilizo Google Chrome, Firefox (já vem nativo), NodeJS, Geckodriver, Chromedriver, RVM para trabalhar com o gerenciamento de versões do ruby e é exatamente o que eu falo pra ele fazer na pré dependência:

  - sudo apt-get install libxss1 libappindicator1 libindicator7 -- Adiciono as libs necessárias para instalar o Chrome;
  - wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -- Baixo o Chrome do servidor via wget;
  - sudo dpkg -i google-chrome*.deb -- Descompacto o pacote;
  - sudo apt-get install -f -- Instalo o Google Chrome;
  - sudo apt-get install jq nodejs curl -qy -- Instalo NodeJS;
  - npm install -g geckodriver -- Com o Node, instalo o geckdriver;
  - npm install -g chromedriver@2.25 -- Com o Node, instalo o chromedriver em uma versão estável;
  - gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 -- Add as libs para o RVM;
  - curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2 -- Instalo o rvm já com a versão 2.2.2 (ou qualquer outra).

Depois das pré dependências, é hora de mandá-lo fazer algumas coisas pra mim em override:
  - rvm use . -- Para utilizar a versão que eu instalei via RVM;
  - gem install bundler -- Com o ruby instalado, peço para instalar a gem bundler;
  - bundle install -- Como estou dentro da raiz do projeto, que possui o Gemfile, já peço pra dar bundle e instalar todas as gems e suas dependências.

PS: Posso colocar qualquer outros comandos que possam fazer sentido para mim dentro do meu contexto OK, nesse caso, são apenas as coisas que eu estou utilizando nesse repositório OK.
```

```ruby
test:
 override:
   - cd cucumber; cucumber -p chrome -p qa --tags @gp_cadastro

Essa parte é a mais importante, pois é exatamente nesse bloco :test que você define quais testes você quer colocar dentro da sua suíte. Se você reparar, tem um [cd cucumber;] que nesse caso faz entrar dentro da pasta cucumber para depois execuutar os testes, de novo, no meu contexto, na forma como criei o ecossitema do meu projeto, eu resolvi ter essa pasta cucumber ok. O teste é o que eu faria na mão rodando na minha máquina:

  - cd cucumber; cucumber -p chrome -p qa --tags @gp_cadastro

Só para dar um overview, o -p chrome é pra rodar no google chrome, e o -p qa é porque eu defini um ambiente de QA para que os meus testes possam ser executados =), coisa boba, mas se bater o olho vai conseguir identificar e ler o projetinho.
```

Bom, mas não acaba por ai, depois que eu configurei o arquivo circle.yml vou precisar de fato colocar meus testes no circleci neh O.o e para isso vamos acessar o site do [circle] (https://circleci.com) e clicar no link em cima do lado direito da tela chamado Log in e depois logar com seu github ou bitbucket. Agora seguir:

1. Clicar no menu do lado esquero no botão ADD PROJECTS;
2. Escolher seu github;
3. Escolher o projeto que você quer já dar build.

Agora você vai ver a mágica acontecer, vai ver tudo sendo instalado bonitinho, dando verde em tudo, da até vontade de chorar de felicidade =). Você vai ver ao vivo e a cores tudo rolando da melhor forma possível, sem enrolações rsrsr.
E quando chegar na hora de executar o teste, ele vai rodar em "headles" e vai pasar lindamente. Porque as "", porque de fato, pra gente olhando o circle, parece em headless porque ele não ta abrindo o navegador, MAS, ele está sim, como se tivesse na sua máquina local, mas se o objetivo é ter os testes realmente em headles, configure seus testes para rodar em headless e depois instale o phantom ou xvfb ou qualquer coisa no arquivo circle.yml e taca pau.

Ai agora o mais legal é..... pega o repositório e faça qualquer alteração, por mais simples que seja, commita e da um push e observe o bendito do circle executando a nova build pra você assim, de grátis.

Bom galera, espero de s2 que tenham gostado, o circle é tão simples de usar que dá até gosto de se aprofundar mais nessa disciplina legal chamada de Ops, fora o upgrade que vai dar no cv não é =). 

Essa foi de coração seus lindos. Vou escrever um mais pra frente falando sobre schedular os testes e fazê-los rodar no horário que eu quiser e da forma que eu quiser e como configurar para que a cada commit no projeto na empresa que você trabalha faça que os testes sejam executados. Não falei para não ficar muito extenso ok.
