# I. CARGA DE LIBRERÍAS =====
library(arrow)
library(tidyverse)

# II. CARGAR DATOS DE CENSO 2024 (Conexión a Datasets) ====
# Usamos open_dataset para no saturar la memoria RAM
viviendas_censo2024 <- open_dataset("/Users/sebastianmansillacarcamo/Desktop/RC2024/Parquet/viv_hog_per_censo2024/viviendas_censo2024.parquet")
hogares_censo2024 <- open_dataset("/Users/sebastianmansillacarcamo/Desktop/RC2024/Parquet/viv_hog_per_censo2024/hogares_censo2024.parquet")
personas_censo2024 <- open_dataset("/Users/sebastianmansillacarcamo/Desktop/RC2024/Parquet/viv_hog_per_censo2024/personas_censo2024.parquet")

# III. DEFINIR CÓDIGO DE COMUNA ====
CODIGO_QUELLON <- 10208

# IV. CREAR DATASETS FILTRADOS PARA QUELLÓN ====

# 1. Viviendas Quellón
viviendas_C2024_Quellon <- viviendas_censo2024 %>%
  filter(comuna == CODIGO_QUELLON) %>%
  collect() # Carga el resultado final en memoria

# 2. Hogares Quellón
hogares_C2024_Quellon <- hogares_censo2024 %>%
  filter(comuna == CODIGO_QUELLON) %>%
  collect()

# 3. Personas Quellón
personas_C2024_Quellon <- personas_censo2024 %>%
  filter(comuna == CODIGO_QUELLON) %>%
  collect()

# V. EXPORTAR A CSV ====
# Estos archivos se guardarán en tu directorio de trabajo actual
write_csv(viviendas_C2024_Quellon, "viviendas_C2024_Quellon.csv")
write_csv(hogares_C2024_Quellon, "hogares_C2024_Quellon.csv")
write_csv(personas_C2024_Quellon, "personas_C2024_Quellon.csv")

# Mensaje de confirmación
print("Datasets creados y exportados exitosamente para la comuna de Quellón.")
