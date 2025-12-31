# I. CARGA INICIAL DE DATOS CARTOGRÁFICOS ====

library(arrow)
manzanas <- read_parquet("/Users/sebastianmansillacarcamo/Desktop/RC2024/Geoparquet/Cartografía_censo2024_R10/Cartografía_censo2024_R10_Manzanas.parquet")
library(dplyr)
glimpse(manzanas)

manzanas_quellon_urbano <- manzanas |> 
  filter(CUT == 10208,
         AREA_C == "URBANO")

library(sf)

# convertir a sf
manzanas_quellon_urbano_sf <- manzanas_quellon_urbano |> 
  st_as_sf(crs = 4326)

manzanas_quellon_urbano_sf

library(ggplot2)

manzanas_quellon_urbano_sf |> 
  ggplot() +
  geom_sf() +
  theme_minimal(base_size = 10)

# II. CARGA DE DATOS CARTOGRÁFICOS Y MAPA INTERACTIVO CON MB LEAFLET
# Filtrar Quellón Urbano
manzanas_quellon_urbano <- manzanas |> 
  filter(CUT == 10208, 
         AREA_C == "URBANO")

# Convertir a sf y asegurar que el CRS sea WGS84 (necesario para Leaflet)
# Nota: st_as_sf crea el objeto, st_transform asegura que Leaflet lo lea bien
manzanas_sf <- manzanas_quellon_urbano |> 
  st_as_sf(crs = 4326) |> 
  st_transform(4326)

# II. GENERACIÓN DE MAPA INTERACTIVO CON LEAFLET ====

leaflet(manzanas_sf) |> 
  # Añadir un mapa base (opcional, puedes usar addTiles() para ver calles)
  addProviderTiles(providers$CartoDB.Positron) |> 
  # Dibujar las manzanas con color plano
  addPolygons(
    fillColor = "#d3d3d3", # Color azul plano
    fillOpacity = 0.5,      # Transparencia del relleno
    color = "black",        # Color del contorno (borde de manzana)
    weight = 1,             # Grosor del contorno
    highlightOptions = highlightOptions(
      weight = 3,
      color = "#666",
      fillOpacity = 0.9,
      bringToFront = TRUE
    ),
    label = ~paste("Manzana ID:", row.names(manzanas_sf)) # Etiqueta al pasar el mouse
  )