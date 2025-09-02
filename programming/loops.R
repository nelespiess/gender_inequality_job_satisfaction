# For-Loop
for (i in c(1, 2, 3, 4, 10)) {
  cat("i=", i, "\n")
  for (x in c(1, 3, 6)) {
    #...
    a <- x ^ i 
    cat("a=", a, "\n")
  }
  
  if (a > 100) {
    warning("a is to large!")
  }
 
}


# While-loop
error <- 1000
while(x > 1) {
  print(x)
  x <- x/2
}



