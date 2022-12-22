


# 1. Data index DM2 segons codi diagnostic #
dt_codis<-readxl::read_excel(conductor_codis,col_types = "text") %>% select(domini,cod,agr) %>% filter(agr=="DM2")
dt_index1<-dt_diagnostics %>% semi_join(dt_codis,by="cod") %>% group_by(idp) %>% slice(which.min(dat)) %>% ungroup() %>% transmute(idp,dtindex=as.character(dat))


# 2. Data index DM2 segons HbA1c >=6.5 # 
# Busco la data minima  d'una GLICADA >=6.5, de cada pacient.
dt_index2<-dt_variables %>% filter(cod=="GLICADA") %>% filter(val>=6.5) %>% group_by(idp) %>% slice(which.min(dat)) %>% ungroup() %>% transmute(idp,dtindex_HB=as.character(dat))

# 3. Data index DM2 segons Farmacs antidiabetics prescrits
dt_codis<-readxl::read_excel(conductor_codis,col_types = "text") %>% select(domini,cod,agr) %>% 
  filter(domini=="farmacs" & agr=="ANTIDIAB") %>% distinct(cod) %>% mutate(agr="ANTIDIAB")
  
dt_temp_primeradata<-
  dt_prescripcions %>% semi_join(dt_codis,by="cod") %>% 
  agregar_prescripcions(bd.dindex = "22000101", dt.agregadors = dt_codis,finestra.dies = c(-Inf, + Inf),agregar_data = T) %>% 
  select(idp,dtindex=FP.ANTIDIAB)

dt_ANTIDIAB_CUMUL<-
  dt_prescripcions %>% semi_join(dt_codis,by="cod") %>% 
  agregar_prescripcions(bd.dindex = "22000101", dt.agregadors = dt_codis,finestra.dies = c(-Inf, + Inf),agregar_data = F) %>% 
  filter(FP.ANTIDIAB>90) %>% select(-dtindex)

dt_index3a <-dt_ANTIDIAB_CUMUL %>% left_join(dt_temp_primeradata,by="idp")  %>% mutate(dtindex=data.to.string(dtindex))

# 4. Data index DM2 segons Farmacs antidiabetics dispensats/facturats
dt_index3b<-
  dt_facturacions %>% semi_join(dt_codis,by="cod") %>% select(idp,cod,dat,env) %>% distinct() %>% 
  group_by(idp) %>% summarise(sum_env=sum(env), data_1a=min(dat)) %>% ungroup() %>% 
  filter(sum_env>=3) %>% 
  select(idp,dtindex=data_1a) %>% mutate(dtindex=paste0(dtindex,"15"))

dt_index3<-dt_index3a %>% bind_rows(dt_index3b) %>% group_by(idp) %>% slice(which.min(dtindex)) %>% ungroup() %>% select(idp,dtindex_FX=dtindex)


# 6. Data index DM2 segons complicacions de la diabetis (RD , Retino, Neuro diabetica etc.. )
dt_codis<-readxl::read_excel(conductor_codis,col_types = "text") %>% select(domini,cod,agr,Comp_DM) %>% filter(!is.na(Comp_DM)) %>% 
  distinct(cod)

dt_index4<-dt_diagnostics %>% 
  semi_join(dt_codis,by="cod") %>% group_by(idp) %>% slice(which.min(dat)) %>% ungroup() %>% select(idp,dtindex=dat) %>% 
  transmute(idp,dtindex_comp=as.character(dtindex))


######### Combinació de criteris per DM2

dt_index1 (DM2)

### Dos criteris entre els 2 seguents
dt_temp<-dt_index2 %>% full_join(dt_index3) %>% full_join(dt_index4) %>% mutate(COUNT_HB2=dtindex_HB,COUNT_FX=dtindex_FX,COUNT_comp=dtindex_comp)
dt_temp<-mutate_at(dt_temp, vars( starts_with("COUNT_") ), funs( if_else(.==0  | is.na(.)  ,0,1)))
dt_temp<-dt_temp%>%mutate(COUNT=COUNT_HB2+COUNT_FX+COUNT_comp)%>%filter(COUNT>=2) %>% mutate(data_min=pmin(dtindex_HB,dtindex_FX,na.rm = T)) %>% 
  select(idp,dtindex =data_min)

# Fusió de dos criteris
dt_index_global<-dt_index1 %>% bind_rows(dt_temp) %>% group_by(idp) %>% slice(which.min(dtindex))




