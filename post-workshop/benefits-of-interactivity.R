library("tidyverse")
library("rfigshare")
library("ggraph")
library("tidygraph")
library("igraph")
library("RColorBrewer")
library("highcharter")
library("visNetwork")

## ---- Physical comparison between groups ----
## Data from http://ilabour.oii.ox.ac.uk/online-labour-index/
## (https://doi.org/10.6084/m9.figshare.3761562)

region_import %>%
  filter(timestamp == max(timestamp)) %>%
  group_by(country_group, occupation) %>%
  summarise(jobs.in.occupation = sum(count)) %>%
  arrange(desc(jobs.in.occupation)) %>%
  ungroup() %>%
  mutate(country_group = fct_reorder(country_group, jobs.in.occupation)) %>%
  hchart(
    type = "bar",
    hcaes(
      x = country_group,
      y = jobs.in.occupation,
      group = occupation
    )
  )


## ---- Network ----

## Data from https://shiring.github.io/networks/2017/05/15/got_final
## and https://www.kaggle.com/mylesoneill/game-of-thrones

got_nodes <- read_csv("data/GoT_nodes.csv")
got_edges <- read_csv("data/GoT_edges.csv")

superculture_colours <- tibble(
  superculture = unique(got_nodes$superculture),
  color = brewer.pal(12, "Paired")
)

got_nodes <- got_nodes %>%
  left_join(superculture_colours)

got_igraph <- graph_from_data_frame(
  got_edges,
  vertices = got_nodes,
  directed = FALSE
) %>%
  simplify()

got_igraph %>%
  visIgraph() %>%
  visOptions(highlightNearest = TRUE)

