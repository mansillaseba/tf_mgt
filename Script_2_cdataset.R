# I. CARGA DE LIBRERÍAS =====
library(arrow)
library(tidyverse)
library(janitor) # Necesario para la función de redondeo recomendada
library(kableExtra) # Para la tabla HTML sofisticada

# III. CREAR VARIABLES PARA FILTRO DE COMUNA Y ÁREA ====
CODIGO_QUELLON <- 10208
CODIGO_QUELLON_URBANA <- 1 # 1 = Urbano, 2 = Rural
CODIGO_QUELLON_RURAL <- 2 # 1 = Urbano, 2 = Rural

# IV. PERSONAS POR ÁREA
poblacion_comuna_por_area <- personas_C2024_Quellon %>%
  
  # Paso 1: Filtrar la base de datos únicamente para la comuna 10208.
  filter(comuna == 10208) %>%
  
  # Paso 2: Agrupar por la variable 'area' (1=Urbano, 2=Rural) y contar el total de personas (registros).
  count(area, name = "poblacion_total") %>%
  
  # Paso 3: Opcional - Etiquetar las categorías de 'area' para mayor claridad.
  mutate(
    area_etiqueta = case_when(
      area == 1 ~ "Urbana",
      area == 2 ~ "Rural",
      TRUE ~ "No aplica/Otro" # Manejo de posibles casos no esperados
    )
  ) %>%
  
  # Paso 4: Ejecutar la consulta y cargar el resultado en memoria (data.frame)
  collect()

print(poblacion_comuna_por_area)

# === TABLA HTML CON VALORES DE PERSONAS POR ÁREA.

# Carga de librerías necesarias
#install.packages("kableExtra")
# Carga de librerías necesarias
library(dplyr)
library(janitor)    # Para la función adorn_totals
library(kableExtra) # Para la tabla HTML sofisticada

poblacion_comuna_por_area <- personas_C2024_Quellon %>%
  filter(comuna == 10208) %>%
  count(area, name = "poblacion_total") %>%
  mutate(
    Área = case_when(
      area == 1 ~ "Urbana",
      area == 2 ~ "Rural",
      TRUE ~ "No aplica/Otro"
    )
  ) %>%
  collect() %>% 
  select(Área, poblacion_total) %>% 
  
  # 1. Primero sumamos (mientras 'poblacion_total' sigue siendo numérica)
  adorn_totals(where = "row", name = "Total") %>%
  
  # 2. Ahora formateamos con punto de miles para la presentación
  mutate(Población = format(poblacion_total, big.mark = ".", scientific = FALSE)) %>%
  select(Área, Población) # Nos quedamos solo con las columnas finales

# --- Generación de la tabla estilo Bootstrap limpio ---
tabla_pobarea <- poblacion_comuna_por_area %>%
  kbl(format = "html", align = "lr") %>% 
  kable_styling(
    bootstrap_options = "hover", 
    full_width = FALSE,           
    position = "left"
  ) %>%
  row_spec(0, bold = TRUE, extra_css = "border-bottom: 2px solid #dee2e6; color: #212529;") %>% 
  column_spec(1:2, extra_css = "padding: 12px; border-bottom: 1px solid #dee2e6;") %>% 
  row_spec(nrow(poblacion_comuna_por_area), bold = TRUE) 

# Para visualizar en RStudio:
print(tabla_pobarea)

