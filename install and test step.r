library(devtools)

setwd("E:\\RXAJ\\RXAJ")
file.edit("NAMESPACE")
check()
load_all()

search()

use_vignette("RXAJ_User_Manual")