library("tidyverse")
library("rfigshare")
library("ggraph")
library("tidygraph")
library("igraph")
library("RColorBrewer")

## ---- Physical comparison between groups ----
## Data from http://ilabour.oii.ox.ac.uk/online-labour-index/
## (https://doi.org/10.6084/m9.figshare.3761562)
fs_deposit_id <- 3761562
deposit_details <- fs_details(fs_deposit_id)

deposit_details <- unlist(deposit_details$files)
deposit_details <-
  data.frame(split(deposit_details, names(deposit_details)), stringsAsFactors = F)

region_import <- deposit_details %>%
  filter(str_detect(name, "bcountrydata")) %>%
  select(download_url) %>%
  .[[1]] %>%
  read_csv() %>%
  mutate(timestamp = as.Date(timestamp))


## ---- Network ----

## Data from https://shiring.github.io/networks/2017/05/15/got_final
## and https://www.kaggle.com/mylesoneill/game-of-thrones

got_nodes <- read_csv("data/GoT_nodes.csv")
got_edges <- read_csv("data/GoT_edges.csv")

got_igraph <- graph_from_data_frame(
  got_edges,
  vertices = got_nodes,
  directed = FALSE
) %>%
  simplify()

