

#https://rstudio-pubs-static.s3.amazonaws.com/240657_5157ff98e8204c358b2118fa69162e18.html
#install.packages("WGCNA")
#BiocManager::install("impute")
library(WGCNA)

# read the file in GTex_data 
GTex_data <- read.csv("GTex_Colon_TPMs.csv")
options(scipen = 999)

# finding the position of KHDRBS gene
grep("KHDRBS",GTex_data$Gene)


# transpose the data (columns to rows and vice-versa)
GTex_transpose <- transposeBigData(GTex_data)
GTex_transpose[2,20803]

# remove ID and gene columns from data 
GTex_newT <- GTex_transpose[3:nrow(GTex_transpose),]
colnames(GTex_newT) <- GTex_data$Gene

# add KHDRBS2 gene column to starting of data
GTex_newSub = subset(GTex_newT, select = -c(`KHDRBS2-OT1`) )
KHDRBS2_OT1<-GTex_newT[,"KHDRBS2-OT1"]
GTex <- cbind(KHDRBS2_OT1,GTex_newSub)
# convert data to numeric type 
GTex <- sapply( GTex, as.numeric )

# Test for Association/Correlation Between Paired Samples (cor.test)
#  create empty dataframe (df)
df <- data.frame(Gene=colnames(GTex), Cor="", P.value="")
estimates = numeric(ncol(GTex))
pvalues = numeric(ncol(GTex))
for (i in 1:ncol(GTex)){
  test <- cor.test(GTex[,1], GTex[,i])
  estimates[i] = test$estimate
  pvalues[i] = test$p.value
}
df$Cor <- estimates
df$P.value <- pvalues
# this will contain correlation and p-value for each gene with KHDRBS2
df
write.csv(df,file = "df_new.csv")


