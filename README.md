# MovieDetails

## MovieDetais é um aplicativo para iOS desenvolvido com a linguagem Swift

  O objetivo deste projeto era replicar o layout de uma tela do aplicativo ToDoMovies,  para mostrar dados de um filme. Os requisitos eram:
* Utilizar dados da API do The Movie DB
* As informações deveriam vir do endpoint _getMovieDetails_
* Substituir as informações de _watched_ para _views_, utilizando o valor de _popularity_ e mudando também o ícone
* Alterar o icone de coração (like), alternando de vazio para cheio, quando clicado
* Abaixo das informações do filme deve haver uma lista de filmes similares, vindos do endpoint _getSimilarMovies_ 

  Desenvolver esta aplicação foi desafiador, pois envolveu diferentes tarefas, como pegar dados da diferentes _endpoints_, criar um layout utilizando UICollectionView com header customizado, para mostrar dados e imagem do filme, e também o tratamento correto dos dados para mostrar o que foi solicitado. Para o desenvolvimento deste projeto foi utilizado o design pattern MVC 
  Também foi implementado uma animação quando o botão de _like_ é clicado, similar a que existe no aplicativo original.

  Abaixo é possível ver o funcionamento do aplicativo e também a animação de _like_.

![](stretchyHeader.gif) | ![](heartBeatAnimation.gif)
------------ | -------------



