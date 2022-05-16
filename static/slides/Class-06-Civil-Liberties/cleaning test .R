pacman::p_load("tidyverse")


incorporation_dat = read_csv("Class-06-Civil-Liberties/data/years_incorporated.csv")

test = incorporation_dat %>% 
  mutate(century = case_when(Year_Incorporated >1800 & Year_Incorporated < 1900 ~ "18th Century"))