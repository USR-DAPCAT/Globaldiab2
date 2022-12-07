#----------------------------------------------------------------#
#rm(list=ls())
#devtools::install_github("USR-DAPCAT/Platan")
#devtools::install_github("USR-DAPCAT/FormatGe")
#devtools::install_github("USR-DAPCAT/Macedonia")
#devtools::install_github("USR-DAPCAT/ggflowchart2")
#----------------------------------------------------------------#
#
#
#
#####
#rai#
#####

rm(list=ls())
gc()
mostra=T
library("dplyr")
library("Platan")
library("FormatGe")
library("Macedonia")
library("ggflowchart2")

dir_dades_desti="dades" 
dir_dades_origen="../DADES/EPIPEU_CAT3/dades" 
if (mostra) {
  dir_dades_origen="../../DADES/GLOBALDIAL2/mostra"
  dir_dades_desti="dades/mostra" }
#--------------------------------------------------------------------------------------------------# 
# global:
# Rang anys per generar dates index
data_inici='20181231'
data_final='20181231'
#--------------------------------------------------------------------------------------------------# 
#---------------------------- LECTURA -------------------------------------------------------------# 
rmarkdown::render(input="./codi/1_lectura.Rmd",
                  output_file=paste0(here::here("outputs/Informe_Lectura_Gran_Funcio_"),Sys.Date()),
                  params = list(dir_dades_desti=dir_dades_desti ,
                                dir_dades_origen=dir_dades_origen,
                                bd.dindex1=data_inici,
                                bd.dindex2=data_final))
#--------------------------------------------------------------------------------------------------# 
rm(list=ls())
gc()
mostra=T
library("dplyr")
library("Platan")
library("FormatGe")
library("Macedonia")
library("ggflowchart2")
data_inici='20231231'
dir_dades_desti="dades" 
dir_dades_origen="../DADES/EPIPEU_CAT3/dades" 
if (mostra) {
  dir_dades_origen="../../DADES/GLOBALDIAL2/mostra"
  dir_dades_desti="dades/mostra" }
#---------------------------- PREPARACIO -------------------------------------------------------------# 
rmarkdown::render(input="./codi/2_preparacio.Rmd",
                  output_file=paste0(here::here("outputs/Informe_Preparacio_Analisi"),Sys.Date()),
                  params = list(dir_dades_desti=dir_dades_desti) )
#--------------------------------------------------------------------------------------------------# 



#######
#jordi#
#######

rm(list=ls())
gc()
mostra=T
library("dplyr")
library("Platan")
library("FormatGe")
library("Macedonia")
library("ggflowchart2")

dir_dades_desti="dades" 
dir_dades_origen="../DADES/EPIPEU_CAT3/dades" 
if (mostra) {
  dir_dades_origen="../DADES/GLOBALDIAL2/mostra"
  dir_dades_desti="dades/mostra" }
#--------------------------------------------------------------------------------------------------# 
# global:
# Rang anys per generar dates index
data_inici='20191231'
data_final='20191231'
#--------------------------------------------------------------------------------------------------# 
#---------------------------- LECTURA -------------------------------------------------------------# 
rmarkdown::render(input="./codi/1_lectura.Rmd",
                  output_file=paste0(here::here("outputs/Informe_Lectura_Gran_Funcio_"),Sys.Date()),
                  params = list(dir_dades_desti=dir_dades_desti ,
                                dir_dades_origen=dir_dades_origen,
                                bd.dindex1=data_inici,
                                bd.dindex2=data_final))
#--------------------------------------------------------------------------------------------------# 
rm(list=ls())
gc()
mostra=T
library("dplyr")
library("Platan")
library("FormatGe")
library("Macedonia")
library("ggflowchart2")

dir_dades_desti="dades" 
dir_dades_origen="../DADES/EPIPEU_CAT3/dades" 
if (mostra) {
  dir_dades_origen="../DADES/GLOBALDIAL2/mostra"
  dir_dades_desti="dades/mostra" }
#---------------------------- PREPARACIO -------------------------------------------------------------# 
rmarkdown::render(input="./codi/2_preparacio.Rmd",
                  output_file=paste0(here::here("outputs/Informe_Preparacio_"),Sys.Date()),
                  params = list(dir_dades_desti=dir_dades_desti) )
#--------------------------------------------------------------------------------------------------# 



