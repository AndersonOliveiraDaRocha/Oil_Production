getwd()
setwd('C:\\Users\\Anderson\\Documents\\UDACITY\\Nanodegree Data Scientist\\Aulas de R\\Gap_Minder\\Gap_Minder\\')
ds <- read.csv('oil_production_total.csv')
names(ds)

#IMPORTANDO A BIBLIOTECA PARA TRATAMENTO DOS DADOS
library(tidyr)
library(ggplot2)

#FAZENDO A TRANSFORMAÇÃO DAS COLUNAS PARA LINHAS
ds_t <- gather(ds,Year,Production,-geo,na.rm = FALSE,convert = TRUE)
#TRATANDO A COLUNA ANO, EXTRAINDO SÓ OS NÚMEROS E IGNORANDO O "X"
ds_t$Year <-substr(ds_t$Year, 2,5)
#VERIFICANDO O TIPO DE DADOS DA COLUNA ANO
typeof(ds_t$Year)
#CONVERTENDO PARA NUMÉRICO
ds_t$Year <- as.numeric(as.character(ds_t$Year))
#OS DADOS BRUTOS ESTÃO EM Tons Of Oil Equivalent (TOE)
#OS MESMOS SERÃO CONVERTIDOS PARA Barrels Of Oil Equivalent (BBOE)
# 1 (TOE) = 6.8412 (BBOE)
ds_t$Production <- ds_t$Production*6.8412


#PRODUÇÃO DO BRAZIL AO LONGO DOS ANOS
ggplot(data = subset(ds_t,ds_t=='Brazil'), aes(x = Year, y = Production/1000000))+
  geom_line(color = "#00AFBB", size = 2)+
  ylab("Produção em milhões de BBOE (Barris de Óleo Equivalente)")+
  xlab("Ano")+
  ggtitle("PRODUÇÃO DE PETRÓLEO NO BRASIL AO LONGO DOS ANOS")



