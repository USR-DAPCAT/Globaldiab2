devtools::install_github("USR-DAPCAT/Platan",build_vignettes = TRUE)

library("Platan")

generar_mostra_fitxers(
  directori = "dades",
  fitxer_poblacio = "GLOBALDIAB2_entregable_poblacio_20221118.rds",
  mida_mostra = 10000,
  prefix = "test",
  directori_test = "mostra",
  idp = "idp",
  llavor = "1234"
)