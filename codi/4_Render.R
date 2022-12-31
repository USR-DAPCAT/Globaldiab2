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
mostra=F

dir_dades_desti="dades" 
dir_dades_origen="../DADES/GLOBALDIAB2" 
if (mostra) {
  dir_dades_origen="../DADES/GLOBALDIAB2/mostra"
  dir_dades_desti="dades/mostra" }
#--------------------------------------------------------------------------------------------------# 
# global:
#--------------------------------------------------------------------------------------------------# 
#---------------------------- LECTURA -------------------------------------------------------------# 
rmarkdown::render(input="./codi/1_lectura.Rmd",
                  output_file=paste0(here::here("outputs/Informe_Lectura_Gran_Funcio_"),Sys.Date()),
                  params = list(dir_dades_desti=dir_dades_desti ,
                                dir_dades_origen=dir_dades_origen))
#--------------------------------------------------------------------------------------------------# 
rm(list=ls())
gc()
mostra=F

dir_dades_desti="dades" 
dir_dades_origen="../DADES/GLOBALDIAB2" 
if (mostra) {
  dir_dades_origen="../DADES/GLOBALDIAB2/mostra"
  dir_dades_desti="dades/mostra" }
#---------------------------- PREPARACIO -------------------------------------------------------------# 
rmarkdown::render(input="./codi/2_Analisi_preparacio.Rmd",
                  output_file=paste0(here::here("outputs/Informe_exploratori"),Sys.Date()),
                  params = list(dir_dades_desti=dir_dades_desti) )
#--------------------------------------------------------------------------------------------------# 

