

agregar_prescripcions<-function(dt=PRESCRIPCIONS,bd.dindex=20161231,dt.agregadors=CATALEG,prefix="FP.",finestra.dies=c(0,0),camp_agregador="agr",agregar_data=F, acumular=NULL,cataleg_mana=F){
  
  # dt=dt_prescripcions %>% semi_join(dt_codisAD,by="cod") %>% filter(idp=="00d79410ce05217612c77d1b38b85970a7622a56")
  # bd.dindex=22500101
  # finestra.dies=c(-Inf,+Inf)
  # dt.agregadors=dt_codisAD
  # prefix="FP."
  # camp_agregador="agr"
  # agregar_data=F
  # acumular=NULL
  # acumular="dosis_dia"
  # acumular=NULL
  
  # Recode numeros infinits
  finestra.dies=ifelse(finestra.dies==+Inf,99999,finestra.dies)
  finestra.dies=ifelse(finestra.dies==-Inf,-99999,finestra.dies)
  
  ## afegir en dataindex de BDINDEX si bd.dindex<>""
  #### Afegir + data index (+dtindex) en l'historic de problemes
  dt<-Platan::afegir_dataindex(dt,bd.dindex)
  
  ##### Arreglar dades
  dt<-dt %>% mutate(
    dat=lubridate::ymd(dat),
    dbaixa=ifelse(is.na(dbaixa),30160101,dbaixa),
    dbaixa=lubridate::ymd(dbaixa),
    dtindex=lubridate::ymd(dtindex))
  
  ## arreglar CATALEG 
  dt.agregadors<-dt.agregadors %>% select_("cod","agr"=camp_agregador)
  dt.agregadors<-dt.agregadors %>% filter(!is.na(agr))
  
  prescripcions_agr<-dt %>% 
    dplyr::select(idp,dtindex,cod,dat,dbaixa, acumular) %>%
    # Calculo els dies de solapament per codi (cod) 
    dplyr::mutate(overlap = pmax(pmin(dtindex+lubridate::days(finestra.dies[2]), dbaixa) - pmax(dtindex+lubridate::days(finestra.dies[1]), dat) + 1,0),
                  overlap=as.numeric(overlap)) %>%
    filter(overlap>0) # Elimino els que no xafen la finestra (overlap==0) 
  
  # Faig copia per captutar primerar data
  prescripcions_agr_copia<-prescripcions_agr %>% dplyr::inner_join(dplyr::select(dt.agregadors,c(cod,agr)), by="cod") %>% 
    dplyr::distinct(idp,dtindex,cod,dat,agr,.keep_all = TRUE)
  # Capturo l'agregador cataleg i elimino repetits
  if (is.null(acumular)) {
    prescripcions_agr<-prescripcions_agr %>% 
      dplyr::inner_join(dplyr::select(dt.agregadors,c(cod,agr)), by="cod") %>%       # Capturo agregador del cataleg
      dplyr::distinct(idp,dtindex,cod,agr,.keep_all = TRUE)              # Eliminar duplicats PER idp-dtindex-cod-agr 
  }
  
  if (!is.null(acumular)) {
    acumular<-rlang::sym(acumular)
    prescripcions_agr<-prescripcions_agr %>% 
      dplyr::inner_join(dplyr::select(dt.agregadors,c(cod,agr)), by="cod") %>%       # Capturo agregador del cataleg
      dplyr::distinct(idp,dtindex,cod,agr,!!acumular,.keep_all = TRUE)              # Eliminar duplicats PER idp-dtindex-cod-agr 
  }
  
  # Agregaci?? de temps acumulats (dies) / o dosis o primera data dins finestra 
  if (!(agregar_data) & is.null(acumular)) {
    # suma dies acumulats
    prescripcions_agr<-prescripcions_agr %>%
      dplyr::group_by(idp,dtindex,agr) %>% 
      dplyr::summarise(FX=sum(overlap,na.rm=T)) %>% 
      dplyr::ungroup() }
  
  # Si hi ha dada (i.e dosis) per acumular 
  if (!is.null(acumular)) {
    prescripcions_agr<-prescripcions_agr %>%
      dplyr::group_by(idp,dtindex,agr) %>% 
      dplyr::summarise(FX=sum(overlap*!!acumular,na.rm=T)) %>% 
      dplyr::ungroup() }
  
  #  Si s'ha d'agregar la primera data de prescripci?? dins finestra de temps 
  if (agregar_data) {
    
    # Selecciono primera data dins de l'interval
    prescripcions_agr <- prescripcions_agr_copia %>% 
      
      dplyr::mutate (
        int1=dtindex+lubridate::days(finestra.dies[1]),    
        data0=ifelse(dat>=int1,dat,int1),               # Si solapament inclou tota la finestra afago limit inferior de la finestra
        data0=lubridate::as_date(data0)) %>% 
      as_tibble() %>%
      dplyr::select(idp,dtindex,agr,dat=data0) %>% 
      dplyr::group_by(idp,dtindex,agr) %>% 
      dplyr::slice(which.min(dat)) %>%                  #
      dplyr::ungroup() %>% 
      dplyr::rename(FX=dat)}
  
  # Previ aplanamenta Si vull agregar agregadors missings de cataleg he d'afegir-los abans d'aplanar
  
  if (cataleg_mana) {
    # Selecciono agregadors en cataleg sense codi en dt
    # tots els codis que tenen algun agregador en dt i els que no
    
    # prescripcions_agr %>% distinct(agr) # Aquests serien els agregadors de prescripci?? on tinc alguna prescripci??
    # dt.agregadors %>% distinct(agr) # Aquests son els del cataleg
    
    pp<-dplyr::select(dt.agregadors,agr) %>% distinct() %>% anti_join(prescripcions_agr %>% distinct(agr),by="agr") # Aquests son els prescripci?? = 0 
    porca<-prescripcions_agr %>% distinct(idp,dtindex) %>% merge(pp) %>% as_tibble() 
    # Afegeixo en dt.temp els nous agregadors buits i fusiono amb dt.temp
    prescripcions_agr<-prescripcions_agr %>% bind_rows(porca)
  }
  #
  
  # Aplanamenta
  prescripcions_agr<-prescripcions_agr %>% tidyr::spread(agr,FX,sep=".")
  
  # Canvi de noms     
  names(prescripcions_agr) <- sub("agr.", prefix, names(prescripcions_agr))   # Afegir prefix en noms de variables 
  
  prescripcions_agr
  
}

#  agregar_facturacio -------------------
#  Retorna tibble (data.table) amb la suma d'envasos o data primera dispensaci?? dins d'una finestra de temps per idp-dataindex      
#  Arguments: historic de f