#leitura e agragação dos dados do finbra (02-jan-24, 12:45h)

# Carregando os pacotes
 .libPaths('D:\\Dimitri\\Docs 17-out-15\\R\\win-library\\3.1') #caminho dos pacotes
 library('xlsx')         #para ler/criar arquivos xlsx
 library('ggplot2')      #Grficos (mais usado)
 library('reshape2')     #para remodular data.frames
 library('dplyr')        #manipulao de dados - tydiverse
 library('data.table')   #para funo fread()
 library('stringr')      #funes de string  - tydiverse
 library('magrittr')     #para mudar nome de colunas

 #funoes espaciais
 library('RColorBrewer')
 library(scales)
 library(lattice)

 #lendo dados de municípios/regiao
 regs <- readODS::read_ods('RELATORIO_DTB_BRASIL_MUNICIPIO.ods', sheet = 1)
 regs <- regs[regs$UF == 42, c(7,8,12,13)] #selecuonando apenas as variáveis de interesse
 #regs$cod6 <- with(regs, floor(`Código Município Completo`/10))

 #lendo os dados do finbra 
 #baixar em 'https://siconfi.tesouro.gov.br/siconfi/pages/public/consulta_finbra/finbra_list.jsf'

 finbra_22 <- read.csv('./finbra_MUNEST_DespesasporFuncao(AnexoI-E)/finbra.csv', sep = ';', , skip = 3, dec = ',')

 #manipulando os dados
 finbra_22 <- finbra_22[which(with(finbra_22, Coluna == 'Despesas Pagas' & 
                        Conta %in% c('10 - Saúde', '12 - Educação'))),]

 finbra_22 <- dplyr::left_join(finbra_22[,c(2,6,8)], regs[,c(2,3)], by = c('Cod.IBGE' = 'Código Município Completo'))

 gastos_meso <- aggregate(Valor ~ Conta + Nome_Mesorregião, FUN = sum, data = finbra_22)
 gastos_meso <- tidyr::spread(gastos_meso, value = Valor, key = Nome_Mesorregião)
