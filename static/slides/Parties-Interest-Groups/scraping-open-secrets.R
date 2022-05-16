pacman::p_load("tidyverse", "rvest")


root <- "https://www.opensecrets.org/federal-lobbying/top-spenders?cycle="

# second part of url (election years as a sequence)
year <- seq(from = 1998, to = 2020, by = 2)

# construct urls by pasting first and second parts together
urls <- paste0(root, year)

# map the scrape_pac function over list of urls --------------------------------

scrape_pac <- function(url) {
  
  # read the page
  page <- read_html(url)
  
  # exract the table
  pac <-  page %>%
    # select node .DataTable (identified using the SelectorGadget)
    html_element(".DataTable-Partial") %>%
    # parse table at node td into a data frame
    #   table has a head and empty cells should be filled with NAs
    html_table("td", header = TRUE, fill = TRUE) %>%
    # convert to a tibble
    as_tibble()
  
  # rename variables
  pac <- pac %>%
    # rename columns
    rename(
      name = `Lobbying Client`,
      total_spent = `Total Spent`
    )
  
  # fix name
  pac <- pac %>%
    # remove extraneous whitespaces from the name column
    mutate(name = str_squish(name))
  
  # add year
  pac <- pac %>%
    # extract last 4 characters of the URL and save as year
    mutate(year = str_sub(url, -4))
  
  # return data frame
  pac
  
}


pac_all <- map_dfr(urls, scrape_pac)

# write data -------------------------------------------------------------------

write_csv(pac_all, path = here::here("Parties-Interest-Groups","data", "pac-all.csv"))