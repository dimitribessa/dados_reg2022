 #leitura dados PNAD Contnua 2018 (13-mar-21, 10:18h)
 #alterado em 23-nov-23, 09:20h

 
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

 library('survey')
 options(survey.lonely.psu="adjust")
 library('PNADcIBGE') #pacote do ibge para extrao dos dados da pnad
 #manual do pnadc em https://rpubs.com/gabriel-assuncao-ibge/pnadc
 
 
 #Selecionando diretrio
 setwd('G:/Meu Drive/Documentos/Fiesc/2023')
 
 #lendo os dados da PNAD 2018
 dado_pnad <-  get_pnadc(year = 2022, topic = 4)#read_pnadc('./PNADC_2018_visita5.txt',paste0('input_PNADC_2018_visita5_20210104.txt'))
 

 #dadoi <- pnadc_deflator(dadoi, paste0('./',ano,'/deflator_PNADC_2020_trimestral_010203.xls'))

 #organizando os dados
 dado_pnad$variables$classe_trab <- with(dado_pnad$variables, ifelse(V4012 %in% c(1,3) & V4029 == 1,'Com carteira',
                                          ifelse(V4012 %in% c(1,3) | V4029 == 2,'Sem carteira',
                                          ifelse(V4012 %in% c(2,4) & V4029 == 1,'Setor Pblico',
                                          ifelse(V4012 == 5,'Empregador',
                                          ifelse(V4012 == 6,'Conta prpria', 'Outros'))))))
                                          
  #quantitativo
 dado_pnad$variables$ones <- 1
 
 #.ps A pnad j disponibiliza os pesos com posestratificao!!! (13-mar-2, 23:29h)
             
 #design object (ver em asdfree.com)             
 #obs. estudar melhor os detalhes aqui
 # desig
 #pre_stratified <-
  #  svydesign(
  ##      ids = ~ UPA , 
  #      strata = ~ Estrato, 
  #      weights = ~ V1031 , 
  #      data = dado_pnad ,
  #      nest = TRUE
  #  )

    #estrato / projeao da populao
 #df_pos <- 
  #  data.frame( posest = unique( dado_pnad$posest ) , Freq = unique( dado_pnad$V1030 ) )

 # design final
 #pnadc_design <- postStratify( pre_stratified , ~ posest , df_pos )
 pnadc_design <- dado_pnad
 pnadc_design <- subset(pnadc_design, UF == "Santa Catarina")
 #tipo trabalho
 tipo_trab <- read.csv('./tradutores_editados/cod_tipo.csv', sep = ';', encoding = 'UTF-8')
 #remunerao
 pnadc_design$variables$remun_anual <- pnadc_design$variables$VD4020*12
 remun <- svyby(~remun_anual, ~V4012, pnadc_design, svytotal, na.rm = T)
 remun %<>% as.data.frame
 row.names(remun) <- NULL
 names(remun)[2:3] <- c('remuneracao_total', 'erro_padrao')
 #remun <- remun[remun[,1] != 'Outros',]
 remun[,1] %<>% as.numeric
 remun <- left_join(remun, tipo_trab, by = c('V4012' = 'tipo'))
 remun[,1] <- NULL
 remun <- remun[,c(3,1:2)]
 remun[,2:3] <- round(remun[,2:3],2)
 
 write.table(remun, file = 'remuneracaoSC.csv', row.names = F, sep = ';', fileEncoding = 'UTF-8') 

  #.cnae_domiciliar + tipo rendimento
 cnae_dom <- read.xlsx('./tradutores_editados/edicao_cnaedom.xlsx', sheetIndex = 1, encoding = 'UTF-8')   %>%
  .[,1:5]
 
 remun_cnae <- svyby(~remun_anual, ~V4013 + V4012, pnadc_design, svytotal, na.rm = T)
 row.names(remun_cnae) <- NULL
 teste <- remun_cnae
 teste <- as.data.frame(teste)
 teste$V4013 <- as.numeric(teste$V4013)
 teste <- dplyr::left_join(teste, cnae_dom, by = c('V4013' = 'classe'))

 teste <- aggregate(remun_anual ~ scn_2010 + desc_scn + V4012, FUN = sum, data = teste)
 teste <- tidyr::spread(teste, value = remun_anual, key = V4012)

 write.table(teste, file = 'remuneracaoSC_setor_posicao.xlsx', row.names = F, sep = ';', fileEncoding = 'UTF-8') 
 
