getwd()
setwd('C:\\Users\\Anderson\\Documents\\UDACITY\\Nanodegree Data Scientist\\Aulas de R\\Gap_Minder\\Gap_Minder\\')
ds <- read.csv('oil_production_total.csv')
names(ds)

#IMPORTANDO A BIBLIOTECA PARA TRATAMENTO DOS DADOS
library(tidyr)
library(ggplot2)
library(gridExtra)

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
ds_t$Production <- ds_t$Production/1000000000


#PRODUÇÃO DO BRAZIL AO LONGO DOS ANOS
ggplot(data = subset(ds_t,ds_t$geo=='Brazil'), aes(x = Year, y = Production))+
  geom_line(color = "#00AFBB", size = 2)+
  ylab("Produção em bilhões de BBOE (Barris de Óleo Equivalente)")+
  xlab("Ano")+
  ggtitle("PRODUÇÃO DE PETRÓLEO NO BRASIL AO LONGO DOS ANOS")

p1 <- qplot(x = Year, y = Production, data = subset(ds_t, (ds_t$geo == 'Brazil')),geom = "path")
p2 <- qplot(x = Year, y = Production, data = subset(ds_t, (ds_t$geo == 'United States')),geom = "path")
grid.arrange(p1,p2,ncol=2)


qplot(Year,Production, data = subset(ds_t, (ds_t$geo == 'Brazil'|ds_t$geo=='United States')), geom = "line",color = geo)
ggsave('BR_USA.png')

qplot(x = Year, y = Production, data = subset(ds_t,(ds_t$geo == 'Brazil' | ds_t$geo=='United States')), geom = 'boxplot',color=geo)

ds_t$geo

#PAISES INTEGRANTES DA OPEP
#FONTE https://www.opec.org/opec_web/en/about_us/25.htm

#DATASET SOMENTE COM OS PAISES MEMBROS
ds_opep <- subset(ds_t,(ds_t$geo=='Angola'|ds_t$geo=='Saudi Arabia'|ds_t$geo=='Algeria'|ds_t$geo=='Ecuador'|ds_t$geo=='United Arab Emirates'|ds_t$geo=='Indonesia'|ds_t$geo=='Iran'|ds_t$geo=='Iraq'|ds_t$geo=='Kuwait'|ds_t$geo=='Libya'|ds_t$geo=='Nigeria'|ds_t$geo=='Qatar'|ds_t$geo=='Venezuela'|ds_t$geo=='Gabon'|ds_t$geo=='Congo, Rep.'))

#DIVERSAS GRÁFICOS COM OS MEMBROS DA OPEP
ggplot(data = ds_opep, aes(x = Year, y = Production,colour = as.factor(geo)))+
  geom_bar(size=1.5,stat = "identity")+
  ylab("Produção em bilhões de BBOE (Barris de Óleo Equivalente)")+
  xlab("Ano")+
  ggtitle("PRODUÇÃO DE PETRÓLEO DA OPEP AO LONGO DOS ANOS")+
  facet_wrap( ~ geo)
ggsave('opep_facet.png')

ggplot(data = ds_opep, aes(x = Year, y = Production,fill=geo))+
  geom_bar(size=1.5,stat = "identity")+
  ylab("Produção em bilhões de BBOE (Barris de Óleo Equivalente)")+
  xlab("Ano")+
  ggtitle("PRODUÇÃO DE PETRÓLEO DA OPEP AO LONGO DOS ANOS \n
          DESTAQUE PARA A CRISE DE 1985 \n
          https://economia.uol.com.br/noticias/bloomberg/2014/11/26/colapso-do-petroleo-em-1986-relembra-perfuradores-americanos-do-risco-da-guerra-de-precos.htm")
ggsave('opep_bar.png')

ggplot(data = ds_opep, aes(x = Year, y = Production,colour = as.factor(geo)))+
  geom_freqpoly(stat = "identity",size=1.2)+
  ylab("Produção em bilhões de BBOE (Barris de Óleo Equivalente)")+
  xlab("Ano")+
  ggtitle("PRODUÇÃO DE PETRÓLEO DA OPEP AO LONGO DOS ANOS")
ggsave('opep_freqpoly.png')

