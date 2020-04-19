
path.code= "/Users/JZHU/hwk-4-JiachengZ98/R_code"
path.data.final="/Volumes/Transcend/2020Spring/Econ 470/Econ 470 dataset/Smoking and Obesity/Final"
path.data.ob= "/Volumes/Transcend/2020Spring/Econ 470/Econ 470 dataset/Smoking and Obesity"

library(tidyverse)
library(readxl)
library(anchors)

for (y in 2011:2018){
  ob.path = paste0(path.data.ob,"/Obesity_",y,".csv")
  ob.data = read_csv(ob.path,
                     skip=5,
                     col_names = c("ID","Year","Abbr","state","class","topic","indicator",
                                   "Response","Datasource","Unit","Type","percentage",
                                   "symbol","footnote","low_CI","high_CI","sample_size","stratification",
                                   "type","IndicatorId","LocationOrder","ParentStateDisplayOrder",
                                   "FootnoteType","FootNoteSymbol","FootnoteText","URL","DatasourceAbbr","Agency"),
                     col_types = cols(
                       percentage = col_character()))
  
  ob.data.obesity = ob.data %>% dplyr::select(Year,state,percentage) %>%
    rename(obesity = percentage)%>%
    group_by(state)%>%
    slice(1)
  ob.data.over = ob.data %>% dplyr::select(Year,state,percentage) %>%
  rename(overweight = percentage)%>%
    group_by(state)%>% 
    slice(2)
  ob.data.normal = ob.data %>% dplyr::select(Year,state,percentage) %>%
    rename(normal = percentage)%>%
    group_by(state)%>% 
    slice(3)
  ob.data.under = ob.data %>% dplyr::select(Year,state,percentage) %>%
    rename(underweight = percentage)%>%
    group_by(state)%>% 
    slice(4)
  
  ob.data.up = left_join(ob.data.obesity,ob.data.over) %>% filter(!is.na(state))
  ob.data.low = left_join(ob.data.normal,ob.data.under) %>%filter(!is.na(state))
  ob.data = left_join(ob.data.up,ob.data.low)
  assign(paste0("ob.data.",y),ob.data)
}

ob.data.2016 <- ob.data.2016 %>% filter(state != "Virgin Islands")
full.ob.data <-rbind(ob.data.2011,ob.data.2012,ob.data.2013,ob.data.2014,ob.data.2015,
                     ob.data.2016,ob.data.2017,ob.data.2018)
full.ob.data = full.ob.data %>% replace.value("state","All States and DC (median) **","US")
smoking.obesity.data <- left_join(final.data,full.ob.data) 

write_rds(smoking.obesity.data,paste(path.data.final,"/smoking_obesity_data.rds",sep=""))
write_rds(full.ob.data,paste(path.data.final,"/obesity_data.rds",sep=""))
save.image("Obesity.data")


