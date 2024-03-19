Welcome to our Movie Recommendation Database! This application was designed 
and written by Ishaan Mantripragada, Olivia Xu, and Rohan Jha for our final 
project in Caltech's CS 121 class. We aimed to create a system that provides 
personalized movie recommendations, allowing users to explore a diverse 
collection of movies, search for movies based on specific preferences, as 
well as rate movies. 

Dataset:
We use a dataset of IMBD movie ratings from Kaggle to load our database. 
Here is the link to the dataset: 
https://www.kaggle.com/datasets/thedevastator/imdb-movie-ratings-dataset. 

Creating the database:
To use our application, source in the following files using the following commands:

source setup.sql;
source load-data.sql; (please make sure to obtain the data at link-to-data.txt and place it in the same directory as the rest of your files)
source grant-permissions.sql;
source setup-routines.sql;
source setup-passwords.sql;

After doing this, open a separate terminal window and run the following command:

python3 app.py

Now you are ready to use our application! Our basic menu screen will allow you to 
browse movies, but to access more functionalities such as browsing by a specific
genre, actor or director, please register an account and log in.
We hope you enjoy our database!