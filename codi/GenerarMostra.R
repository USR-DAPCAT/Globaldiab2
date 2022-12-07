library("Platan")
library("FormatGe")

#E:\GoDrive\CIBERDEM\DADES\GLOBALDIAB2

generar_mostra_fitxers(
  directori = "../DADES/GLOBALDIAB2",
  fitxer_poblacio = "GLOBALDIAB2_entregable_poblacio_20221118.rds",
  mida_mostra = 10000,
  prefix = "test",
  directori_test = "mostra",
  idp = "idp",
  llavor = "1234"
)

