
a <- readxl::read_excel(
  "D:/Economia/MESTRADO/DISSERTACAO/Insumos/Dados/Censo 2010/PR/Base informaçoes setores2010 universo PR/EXCEL/Basico_PR.xls") %>% 
  mutate_at(.vars = vars(
    'V001','V002','V003','V004','V005','V006','V007','V008','V009'),#,'V050',
    #'V051','V052','V053','V054','V055','V056','V057','V058','V059','V060',
    #'V061','V062','V063',
    #'V010','V011','V012',
    funs(as.numeric(.))) %>% 
  drop_na(V011) %>% left_join( readxl::read_excel(
    "D:/Economia/MESTRADO/DISSERTACAO/Insumos/Dados/Censo 2010/PR/Base informaçoes setores2010 universo PR/EXCEL/Pessoa03_PR.xls"),
    by="Cod_setor") %>% mutate(quartil=split_quantile(V011.x,type=4)) 

###### RAFA
 fun_pack_rafa <- function(op_quartil,timeint) {

land_use_data <- as.data.frame(op_quartil) %>% 
  mutate(id=TARGET_FID,
         jobs=Total.emp.quart1) %>% 
  select(id,jobs)

travel_matrix <- as.data.frame(Boijosly_results) %>% 
  mutate(from_id=Origem,
         to_id=Destino,
         travel_time=TEMPO.MIN) %>% 
  select(from_id,to_id,travel_time)

df <- accessibility::cumulative_interval(
  travel_matrix = travel_matrix,
  land_use_data = land_use_data,
  interval = c(20,70),
  #cutoff=48,
  opportunity = "jobs",
  travel_cost = "travel_time")
  
}
 
 
input_time_total <- fun_pack_rafa(Boijosly_fromcensus_interp_total)

input_time_quart1 <- fun_pack_rafa(Boijosly_fromcensus_interp_1)

input_time_quart2 <- fun_pack_rafa(Boijosly_fromcensus_interp_2)

input_time_quart3 <- fun_pack_rafa(Boijosly_fromcensus_interp_3)

input_time_quart4 <- fun_pack_rafa(Boijosly_fromcensus_interp_4)


####

func_dtransit_robust <- function(quartile,inputop) {

b <- RM_CWB_SETORES %>% 
  mutate(code_tract=as.numeric(code_tract)) %>% 
  left_join(a, by=c("code_tract"="Cod_setor")) %>% filter(quartil==quartile)

c1 <- Acess_cum %>% left_join(inputop,by=c("TARGET_FID"="id")) %>% st_as_sf(coords=geom,crs=4326) %>% 
  st_transform(crs=4674)

c <- st_join(b,c1) %>% distinct(code_tract,.keep_all = TRUE) %>% 
  mutate_at(.vars = vars('V048','V049','V050','V051','V052','V053','V054',
        'V055','V056','V057','V058','V059','V060','V061','V062','V063','V064'),
            funs(as.numeric(.))) %>% 
  mutate(workinpop=(V048+V049+V050+V051+V052+V053+V054+V055+V056+V057+V058+V059+V060+V061+V062+V063+V064),
         jobs=if_else(is.na(jobs),0,jobs)) %>% 
  select(code_tract,workinpop,jobs)

sumwi = sum(c$workinpop,na.rm=T)
sumca = sum(c$jobs,na.rm=T)
wi = c$workinpop/sumwi
ca = c$jobs/sumca
Dtransit = sum(abs(ca-wi),na.rm=T)*0.5

 print(Dtransit)

return(Dtransit)
}

Dtransit_total <- func_dtransit_robust(c(1,2,3,4),input_time_total)

Dtransit_1 <- func_dtransit_robust(1,input_time_quart1)

Dtransit_2 <- func_dtransit_robust(2,input_time_quart2)

Dtransit_3 <- func_dtransit_robust(3,input_time_quart3)

Dtransit_4 <- func_dtransit_robust(4,input_time_quart4)


#####

Access_ica_shp <- Boijosly_shp %>% 
  left_join(input_time_total,by=c("TARGET_FID"="id")) %>%
  st_as_sf(coords=geom,crs=4326) %>% 
  st_transform(crs=4674)

Access_ica_shp <- Boijosly_shp %>% 
  left_join(as.data.frame(Access_ica_shp),by="TARGET_FID") %>% 
  mutate(geom=geom.y)

Access_ica_shp <- st_join(RM_CWB_SETORES,st_as_sf(Access_ica_shp)) %>% 
  group_by(code_tract) %>% 
  dplyr::summarise(jobs=mean(jobs,na.rm=T)) %>%  
  mutate(percent.cumulat=(jobs/sum(jobs,na.rm=T))*100) 

Acess_ica_shp <- aw_interpolate(
  RM_CWB_EMP_planar,
  source = st_buffer(Acess_ica_shp,0),
  sid = jobs, tid = code_tract,
  weight = "sum", output = "tibble", 
  extensive = c("jobs"))

mapview(Access_ica_shp,
        zcol= "jobs",col.regions = brewer.pal(5,"Reds"),alpha=0.1)


setwd("D:/Economia/MESTRADO/DISSERTACAO/Insumos/Dados/R/Outputs/")

write.csv(c,"inputDtransit_60min.csv")

setwd("D:/Economia/MESTRADO/DISSERTACAO/Insumos/Dados/R/SHPsMaps/")

st_write(Access_ica_shp,"Access_ica_shp.gpkg")
