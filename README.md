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

- Censo 2022 - para os dados de população, foram utilizadas os primeiros dados de população do Censo de 2022, podendo ser acessadas [aqui](https://www.ibge.gov.br/estatisticas/sociais/trabalho/22827-censo-demografico-2022.html);

- Finanças Municipais (FINBRA) - disponibilizada pelo Tesouro Nacional através do Sistema de Informações Contábeis e Fiscais do Setor Público Brasileiro (Siconfi), estes bancos 
    dados contém as receitas e despesas de cada município brasileiro, divididas por sua função orçamentária (mais [aqui](https://portaldatransparencia.gov.br/pagina-interna/603317-funcao-e-subfuncao)). Os dados de despesas podem ser obtidos [aqui](https://siconfi.tesouro.gov.br/siconfi/pages/public/conteudo/conteudo.jsf);

- Pesquisa Nacional de Amostras de Domicílio Contínua (PnadC): Os dados aqui foram obtidos diretamente do ftp do IBGE, utilizando o pacote 'PNADcIBGE'.

## Scripts

Cada script disponibilizado aqui tem uma finalidade diferente, sendo divididas principalmente pela base de dados que se utiliza. Com excessão do *script_expo_sh4.R*, todos os outros
podem ser rodados independentemente.

- _pnad.R_: Aqui a finalidade é obter o rendimento das famílias pela posição da ocupação;

- *script_gastos.R*: A partir dos dados do Finbra, calcula-se os gastos liquidados nas funções de Saúde e Educação, agrupando por mesorregiões;

- *script_populacao.R*: Obter o total e a proporção da população do estado de Santa Catarina, dividida por sua mesorregião;

- *script_expo_ncm.R*: Obter o valor das exportações catarinense, categorizando pelos códigos do Sistema de Contas Nacionais;

- *script_expo_sh4.R*: Obter o valor das exportações catarinense, a partir dos dados do município da empresa exportadora, e categorizá-lo por SCN e mesorregiões.
Tem-se uma ressalva: o dicionário de dados teve que ser adaptado aos códigos SH4 a partir da categorização de NCM>>SCN. Em vista a simplificação, houve caso de conflitos de códigos e para sanar, utilizou aquele de maior valor exportado.

