 #leitura e agragação dos dados do comexstat (21-dez-23)
 #rodar antes o script "script_expo_ncm.R"

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

 #lendo tradutor produto NCM
 tradutor_ncm <- read.xlsx('./tradutores_editados/tradutor COM EXT.xlsx', sheetIndex = 1, encoding = 'UTF-8')
 tradutor_ncm$SH4 <- substr(tradutor_ncm[,1],1,4) %>% as.numeric
 tradutor_ncm$cod_ncm <- as.numeric(tradutor_ncm$Código.NCM)
 tradutor_ncm <- tradutor_ncm[!duplicated(tradutor_ncm$cod_ncm),]

 #tradutor_sh4 <- tradutor_ncm[which(with(tradutor_ncm, !duplicated(SH4,Código.Produto))),]
 tradutor_sh4 <- dplyr::distinct(tradutor_ncm, Código.Produto, SH4)
 
 #sh4_duplicado <- unique(tradutor_sh4[duplicated(tradutor_sh4$SH4),2])
 
 #retirando as duplicidades
 tradutor_sh4 <- purrr::map_df(unique(tradutor_sh4[,2]), function(x){
                dadoi <- tradutor_sh4[tradutor_sh4$SH4 == x,]
                if(nrow(dadoi) == 1){dadoi}else{
                    expo <-  expo_ncm_scn[ expo_ncm_scn$SH4 == x,]
                    expo <- expo[order(desc(expo$VL_FOB)),]
                    if(nrow(expo) == 0){dadoi <- dadoi[1,]}else{
                        dadoi <- dadoi[dadoi$Código.Produto == expo$Código.Produto[1],]
                    }
                    dadoi
                }

 })

 #lendo dados do comexstat

 expo <- data.table::fread('./comexstat/EXP_2022_MUN.csv', sep = ';')
 expo <- expo[expo$SG_UF_MUN == 'SC',] #filtrando apenas o estado de Santa Catarina

 #tratando os dados
 expo <- dplyr::left_join(expo, regs[,-1], by = c('CO_MUN' = "Código Município Completo"))
 expo <- dplyr::left_join(expo,  tradutor_sh4, by = 'SH4')

 expo_scn_mun <- aggregate(VL_FOB ~ Código.Produto, data = expo, FUN = sum)
 
 #exportação por mesorregiuão + código SCN
 expo_meso <- aggregate(VL_FOB ~ Nome_Mesorregião + Código.Produto, data = expo, FUN = sum)
 expo_meso <- tidyr::spread(expo_meso, key = Nome_Mesorregião, value = VL_FOB) 
 
 #exportação por mesorregiuão + código SCN
 expo_meso_sh4 <- aggregate(VL_FOB ~ Nome_Mesorregião + SH4, data = expo, FUN = sum)
 expo_meso_sh4 <- tidyr::spread(expo_meso_sh4, key = Nome_Mesorregião, value = VL_FOB) 

 #lendo códigos sh4
 sh4_nomenc <- openxlsx::read.xlsx('./tradutores_editados/TABELAS_AUXILIARES.xlsx', sheet = 2) %>%
                .[!duplicated(sh4_nomenc[,1]),7:8]
 sh4_nomenc[,1] <- as.numeric(sh4_nomenc[,1]) #transformando em variável numérica


 expo_meso_sh4 <- dplyr::left_join(expo_meso_sh4, sh4_nomenc, by = c('SH4' = 'CO_SH4')) %>%
                    .[,c(1,8,2:7)]
