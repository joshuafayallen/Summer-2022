sims = 1000

winnoswitch = 0 

winswitch = 0

doors = c(1,2,3)


for (i in 1:sims) {
  windoor = sample(doors,1)
  choice = sample(doors,1)
  if (windoor == choice)
    winnoswitch  = winnoswitch + 1
doorsleft = doors[doors!= choice]
if(any(doorsleft == windoor))
  winswitch = winswitch + 1
}

cat("Prob(Car| no switch) = ", winnoswitch/sims, "\\n")

cat("Prob(Car|swicht) = ", winswitch/sims, "\\n")