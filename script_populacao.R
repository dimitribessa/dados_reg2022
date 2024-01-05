#leitura e agragação dos dados de população (02-jan-2024, 12:34h)

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

 #carregando e organizando os dados de população
 #baixar no site do IBGE

 pops_2022 <- read.xlsx('POP2022_Municipios_20230622.xls', sheetIndex = 1, startRow = 2,  encoding = "UTF-8") %>%
              .[which(.$UF == 'SC'),]
 pops_2022$codigo <- paste0(pops_2022[,2],pops_2022[,3]) %>% as.numeric
 
 #realizando os joins e obtendo a proporção
 pops_2022 <- dplyr::left_join(pops_2022, regs[,2:3], by = c('codigo' = 'Código Município Completo'))
 pops_reg <- aggregate(as.numeric(POPULAÇÃO) ~ Nome_Mesorregião, FUN = sum, data = pops_2022)
 pops_reg$prop <- round(pops_reg[,2]/sum(pops_reg[,2]),3) #proporção da população em casa mesorregião

