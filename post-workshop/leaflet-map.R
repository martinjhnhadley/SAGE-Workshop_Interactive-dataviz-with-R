library("leaflet")

quakes %>%
  leaflet() %>%
  addProviderTiles(providers$Esri.OceanBasemap) %>%
  addCircleMarkers(clusterOptions = markerClusterOptions())
