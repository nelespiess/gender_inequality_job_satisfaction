# Conditionals I. --------------------------

for (i in 1:10) {
  print(i)
  if (i %% 2 == 0) {
    print("even")
  } else {
    print("odd")
  }
}

# Conditionals II -------------------------

n <- 1000

for (i in 1:n) {
  if (i %% 1000 == 0) {
  cat("Simulation:",  i, "\n")
  }
}


# 
x <- readline("Give a value for x! ")
print(x)
if (is.numeric(x)) {
  print("x is numeric")
} else {
  print("x is not numeric")
}


## 

x <-rnorm(100)
x <- letters
if (is.numeric(x)) {
  print(mean(x))
} else {
  print(unique(x))
}

# if-else

nele_score <- 0
henrik_score <- 0 


while (nele_score < 5 & henrik_score < 5) {
  
  x <- sample(1:10, size=1)
  
  if (!is.numeric(x)) {
    stop("x must be a numer! Redo!")
  } else if (x < 4) {
    cat("x is small!\n")
  } else if (x >=4 & x <=8) {
    print("x is medium large!")
  } else if (x > 8) {
    print("x is large!")
  } else {
    stop("Something is wrong!")
  }
  
  nele <- as.numeric(readline("Nele's guess: "))
  henrik <- as.numeric(readline("Henrik's guess: "))
  
  nele_score <- nele_score + abs(x - nele)
  henrik_score <- henrik_score + abs(x - henrik)
  
  cat("Henrik:", henrik_score, ", Nele:", nele_score, "\n")

}



### 

counter <- 0
error <- 10000

while(error > 1) {
  error <- error/1.00001
  print(error)
  counter <- counter + 1
  if (counter>=1000) {
    stop("Takes too long!")
  }
}

### END #####################################