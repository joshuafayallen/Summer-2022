

pacman::p_load("gganimate")

spenders_cum_raw = read_csv("data/pac-all.csv") 


spender = spenders_cum_raw %>% 
  mutate(money = str_replace_all(total_spent, "[[$,]]",""),
         money = as.numeric(money)) 


spender_ready = spender %>% 
  group_by(year) %>% 
  arrange(year, desc(money)) %>% 
  mutate(ranking = row_number()) %>% 
  filter(ranking <= 20)

animation = spender_ready %>% 
  ggplot() +
  geom_col(aes(ranking, money, fill = money)) +
  geom_text(aes(ranking, money, label = money), hjust = -0.1) +
  geom_text(aes(ranking, y=0 , label = name), hjust=1.1) + 
  geom_text(aes(x=15, y=max(money) , label = as.factor(year)), vjust = 0.2, alpha = 0.5,  col = "gray", size = 20) +
  coord_flip(clip = "off", expand = FALSE) + 
  scale_x_reverse() +
  scale_y_continuous(label = scales::dollar) +
  theme_minimal() +
  labs(x = NULL) +
  guides(fill = "none") +
  scico::scale_fill_scico(palette = "vik") +
  transition_states(year) +
  enter_fade() +
  exit_fade() + 
  ease_aes('quadratic-in-out') 



animate(animation, width = 1500, height = 432)
```