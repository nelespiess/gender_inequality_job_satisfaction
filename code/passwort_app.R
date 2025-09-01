
library(beepr)


username <- "schuhenr"
password <- "montag"


# Check log in details
myusername <- readline("Gib deinen Benutzernamen an! ")
mypassword <- readline("Gib dein Passwort an! ")


if (myusername %in% username) {
  print("Username exists!")
} else {
  stop("Username does not exist!")
}

if (mypassword == password) {
  print("login successfull!")
} else {
  stop("Wrong password!")
}


