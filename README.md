# RecommenderSystem
Recommender System in R
The Recommender System has been implemented using R Programming language on Windows 10 Operating System. 

To run the project, install the below components:
1. Install the latest version of R from the URL https://cran.r-project.org/mirrors.html
2. Install the latest version of RStudio from https://www.rstudio.com/products/rstudio/download/
3. Install Rtools33.exe from https://cran.rstudio.com/bin/windows/Rtools/ (Optional. Required if package is to be created)

------------------------------------------------------------------------------------------------------------------------------------------
To Run the Project,
1. Open RStudio
2. File > Open project
3. Browse to the folder where the project is copied and open RecommenderSystem\RecommenderSystem.RProj
4. Make sure the input file "train_all_txt.txt" is present in the RecommenderSystem directory.
5. CLick on Build > Build and Reload
6. The output file "output.txt" will be created in the RecommenderSystem folder. This is the output file to be evaluated. (Note: "output_format_2.txt is a intermediate file in m x n matrix format)

------------------------------------------------------------------------------------------------------------------------------------------
To run a different input:
1. Copy the input file to the RecommenderSystem folder
2. In RStudio, Open the R file  RecommenderSystem\R\RecommenderSystem.R which contains the entire code.
3. Update the value of m to number of users.
4. Update the value of n to number of items.
5. If the input file name is different, update it on the 11th line.
6. Click on Build > Build and Reload.
