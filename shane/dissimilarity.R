mat.cor <- read.csv("cor_matrix.csv", sep = "\t") %>% as.matrix
# dist(iris[, 3:4]) %>% class
mat.dis <- 1 - mat.cor
distance <- as.dist(mat.dis)
plot(hclust(distance), 
    main="Dissimilarity = 1 - Correlation", xlab="")
