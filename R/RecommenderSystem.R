#Number of users (m) - Change Value here for a different input set
m <- 943

#Number of items (n) - Change Value here for a different input set
n <- 1682

#Top N correlations (NC) - Set Value for Top N Correlations
NC <- 50

#Reading from input file into input matrix. Input file name can be changed here
input <- read.table("train_all_txt.txt", header = FALSE)

#Created m x n matrix
rec_table = matrix(nrow = m, ncol = n, data=NA, byrow = FALSE, dimnames = NULL)

#Populated the m x n matrix using input matrix
for(i in 1:NROW(input))
  {
    rec_table[input[i,1],input[i,2]] <- input[i,3]
  }

#Created Matrix for Pearson Co-efficient
options(warn=-1)
cor_matrix = cor(t(rec_table), use="pairwise.complete.obs", method = "pearson")
options(warn=0)

#Vector for User Mean rating
user_Rating_Mean = rowMeans(rec_table, na.rm = TRUE, dims = 1)

#Vector for Item Mean rating
item_Rating_Mean = colMeans(rec_table, na.rm = TRUE, dims = 1)

#Normalized the m x n matrix
normalized_rec_table = matrix(nrow = m, ncol = n, data=NA, byrow = FALSE, dimnames = NULL)

for(i in 1:NROW(rec_table))
  {
  for(j in 1:NCOL(rec_table))
    {
      normalized_rec_table[i,j] = rec_table[i,j] - user_Rating_Mean[i]
    }

}


#Normalized Item Mean
normalized_item_Rating_Mean = colMeans(normalized_rec_table, na.rm = TRUE, dims = 1)

#Found the top NC correlated uses for each user
top_correlations = matrix(nrow = m, ncol = NC, data=NA, byrow = FALSE, dimnames = NULL)

for(i in 1:NROW(cor_matrix))
  {
    temp_corr_var = head(order(cor_matrix[i,],decreasing = TRUE, na.last=NA),NC+1)
    top_correlations[i,] = temp_corr_var[-match(c(i),temp_corr_var)]
  }

#Created another matrix for storing the predicted values
output_rec_table = rec_table

#Predicting the values in the matrix
for(u in 1:NROW(output_rec_table))
  {
    for(i in 1:NCOL(output_rec_table))
      {
        if (is.na(output_rec_table[u,i]))
          {
            numerator = 0
            denominator = 0
            for(j in 1:50)
            {
              if (!is.na(normalized_rec_table[top_correlations[u,j],i]))
              {
                numerator = numerator + (normalized_rec_table[top_correlations[u,j],i] * cor_matrix[u,top_correlations[u,j]])
                denominator = denominator + cor_matrix[u,top_correlations[u,j]]
              }

            }
            if(denominator>0 & numerator>0)
              {
                output_rec_table[u,i] = round(user_Rating_Mean[u] + (numerator/denominator), digits = 2)
              }
            if(!is.finite(output_rec_table[u,i]))
            {
              if(is.finite(item_Rating_Mean[i]))
              {
                #output_rec_table[u,i] = round(item_Rating_Mean[i], digits = 2) #Earlier method. Below line is the improved method
                output_rec_table[u,i] = round(user_Rating_Mean[u] + normalized_item_Rating_Mean[i], digits = 2)
              }
              else
              {
                output_rec_table[u,i] = 1
              }
            }

            #Adjust the rating if it goes outside the range of 1-5
            if(output_rec_table[u,i] > 5)
            {
              output_rec_table[u,i] = 5
            }
            if(output_rec_table[u,i]< 1)
            {
              output_rec_table[u,i] = 1
            }
          }
      }
}

#Writing the intermediate matrix to file. This is not the final output.
write.table(output_rec_table, file="output_format_2.txt", row.names=FALSE, col.names=FALSE)

#Converting the matrix to the final output format.
final_output_format = matrix(nrow = m * n, ncol = 3, data=NA, byrow = FALSE, dimnames = NULL)

r <- 1

  for(u in 1:m)
  {
    for(i in 1:n)
    {
      final_output_format[r,1] = u
      final_output_format[r,2] = i
      final_output_format[r,3] = output_rec_table[u,i]
      r <- r+1
    }
  }

#Writing the final output file using the final_output_format matrix
write.table(final_output_format, file="output.txt", row.names=FALSE, col.names=FALSE)
