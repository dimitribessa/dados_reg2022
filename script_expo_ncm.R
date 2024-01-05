 #leitura e agragação dos dados do comexstat (21-dez-23)

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


 #lendo tradutor produto NCM
 tradutor_ncm <- read.xlsx('./tradutores_editados/tradutor COM EXT.xlsx', sheetIndex = 1, encoding = 'UTF-8')
 tradutor_ncm$SH4 <- substr(tradutor_ncm[,1],1,4) %>% as.numeric
 tradutor_ncm$cod_ncm <- as.numeric(tradutor_ncm$Código.NCM)

 tradutor_ncm <- tradutor_ncm[!duplicated(tradutor_ncm$cod_ncm),]

 #lendo dados do comexstat

 expo_est <- data.table::fread('./comexstat/EXP_2022.csv', sep = ';')
 expo_est <- expo_est[expo_est$SG_UF_NCM == 'SC',] #filtrando apenas o estado de Santa Catarina

 #tratando os dados
 expo_est <- dplyr::left_join(expo_est, tradutor_ncm[,c(3,7,8)], by = c('CO_NCM' = 'cod_ncm'))
 
 #totais por produto (SCN + SH4)
 expo_ncm_scn <- aggregate(VL_FOB ~ Código.Produto + SH4, data = expo_est, FUN = sum)

 #totais por produto (SCN)
 expo_scn_est <- aggregate(VL_FOB ~ Código.Produto, data = expo_est, FUN = sum)

 
 