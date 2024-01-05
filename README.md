# Scripts para leitura e manipulação de dados

## Introdução

Este projeto *Git* tem como objetivo compartilhar os passos de elaboração das informações a serem utilizadas no projeto de pesquisa, 
a fim de permitir a replicabilidade de todas as informações geradas aqui.

Os scripts foram construídos em R, e foram divididos de acordo com o propósito e a base de dados utilizada. 

## Base de dados Utilizadas

As base de dados necessárias aqui ou i. estão disponibilizadas neste repositório ou ii. os scripts apontam o caminho para download (como o caso do PNAD e da Rais).

- Divisão Territorial Brasileira  (DTB) - Disponilizada pelo IBGE (acesso [aqui](https://www.ibge.gov.br/geociencias/organizacao-do-territorio/estrutura-territorial/23701-divisao-territorial-brasileira.html)), contém a descrição das mesorregiões e os códigos de identificação de cada município brasileiro;

- Estatísticas de comércio Exterior - Disponibilizados pelo Ministério de Desenvolvimento, Indústria, Comércio e Serviços (MDIC), esta base de dados (disponível [aqui](https://www.gov.br/mdic/pt-br/assuntos/comercio-exterior/estatisticas/base-de-dados-bruta)). Elas estão organizadas de duas formas, sendo uma das bases sendo detalhados pelo NCM ou pelo
    Município da empresa exportadora/importadora;

- Finanças Municipais (FINBRA) - disponibilizada pelo Tesouro Nacional através do Sistema de Informações Contábeis e Fiscais do Setor Público Brasileiro (Siconfi), estes bancos 
    dados contém as receitas e despesas de cada município brasileiro, divididas por sua função orçamentária (mais [aqui](https://portaldatransparencia.gov.br/pagina-interna/603317-funcao-e-subfuncao)). Os dados de despesas podem ser obtidos [aqui](https://siconfi.tesouro.gov.br/siconfi/pages/public/conteudo/conteudo.jsf);

- Pesquisa Nacional de Amostras de Domicílio Contínua (PnadC): Os dados aqui foram obtidos diretamente do ftp do IBGE, utilizando o pacote 'PNADcIBGE'.