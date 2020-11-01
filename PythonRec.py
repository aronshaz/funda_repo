# Importing pandas module
import pandas as pd

# Reading reviews dataset
all_reviews = pd.read_csv('all_reviews.csv',sep=';')

# Creating dataframe for reviews on my favorite movie
fav_movie_reviews = pd.DataFrame(columns = all_reviews.columns.tolist())
fav_movie_reviews = all_reviews[all_reviews.movieName == 'flight']

# Creating dataframe for recommendations and adding columns for relative and absolute increase of ratings
all_recs = pd.DataFrame(columns=all_reviews.columns.tolist()+['relative_increase','absolute_increase'])

#print(all_recs.head(10))
#print(fav_movie_reviews.head(10)

# Defining the authors and ratings of my favorite movie
# idx represents the index number (starting with 0), itterrows functions as a way to go over each individual row in the dataset
for idx, Author in fav_movie_reviews.iterrows():
    author = Author[['Author']].iloc[0]
    score = Author[['Metascore_w']].iloc[0]

# Creating a preliminary list with movies rated higher by reviewers of my favorite movie using the two arguments 
# The author has to be the same as the one who rated by favorite movie and the score has to be higher than the rating of my favorite movie
    prelim_recs = all_reviews[(all_reviews.Author==author) & (all_reviews.Metascore_w>score)]

#print(prelim_recs.head())
    
# Defining the relative and absolute increase of the other ratings compared to my favorite movie
# The pd.options.mode.chained_assignment function disables some irrelevant warning messages 
    pd.options.mode.chained_assignment = None
    prelim_recs.loc[:,'relative_increase'] = prelim_recs.Metascore_w/score
    prelim_recs.loc[:,'absolute_increase'] = prelim_recs.Metascore_w-score

# Adding these movies to the recommendations dataframe
    all_recs = all_recs.append(prelim_recs)
    
# Sorting the recommendations by relative and absolute increase, starting with the highest increase
all_recs = all_recs.sort_values(['relative_increase','absolute_increase'],ascending=False)

# Removing the duplicate movies: mulitple authors can recommend the same movie. Considering the nature of the assignment, these duplicates are therefore removed 
all_recs = all_recs.drop_duplicates(subset='movieName', keep="first")

# Exporting the first 50 recommendations to csv
all_recs.head(50).to_csv("/home/pi/RSL/pythonrecs.csv", sep=";", index=False)

print(all_recs.head(10))
print(all_recs.shape)
            
            
    
        

    
