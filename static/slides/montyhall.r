pacman::p_load("tidyverse", "modelsummary")



iter=  10000 

# defining the doors
doors = c("goat","goat","car")

# initialize dataframe to store the result per iteration


monte_hall = function(iteration){
        
        contestant_door =  sample(doors, size = iteration, replace = TRUE)
        i=1:iteration
        
        #stick_win which is equal to 1 if the contestant_door in current i is car, 0 otherwise.
        #switch_win which is equal to 0 if the contestant_door is equal to car, 1 otherwise.
        stick_win = ifelse(contestant_door == 'car',1,0)
        switch_win = ifelse(contestant_door == 'car',0,1)
        
        stick_prob = cumsum(stick_win)/i
        switch_prob = cumsum(switch_win)/i
        
        #store result in a dataframe
        results = data.frame(i=i, contestant_door=contestant_door, 
                              stick_win=stick_win,  switch_win=switch_win,
                              stick_prob=stick_prob, switch_prob=switch_prob)
        
        return(results)
}

monte_hall_results = monte_hall(iter)







