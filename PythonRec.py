import pandas as pd


all_reviews = pd.read_csv('all_reviews.csv',sep=';')

fav_movie_reviews = pd.DataFrame(columns = all_reviews.columns.tolist())
fav_movie_reviews = all_reviews[all_reviews.movieName == 'the-conjuring']
all_recs = pd.DataFrame(columns=all_reviews.columns.tolist()+['relative_increase','absolute_increase'])

#print(all_recs.head())
#print(fav_movie_reviews.head())


for idx, Author in fav_movie_reviews.iterrows():
    author = Author[['Author']].iloc[0]
    score = Author[['Metascore_w']].iloc[0]

    prelim_recs = all_reviews[(all_reviews.Author==author) & (all_reviews.Metascore_w>score)]
    #print(prelim_recs.head())
    
    pd.options.mode.chained_assignment = None
    prelim_recs.loc[:,'relative_increase'] = prelim_recs.Metascore_w/score
    prelim_recs.loc[:,'absolute_increase'] = prelim_recs.Metascore_w-score
    all_recs = all_recs.append(prelim_recs)
    

all_recs = all_recs.sort_values(['relative_increase','absolute_increase'],ascending=False)

all_recs = all_recs.drop_duplicates(subset='movieName', keep="first")

all_recs.head(50).to_csv("/home/pi/RSL/pythonrecs.csv", sep=";", index=False)
print(all_recs.head(10))
print(all_recs.shape)
            
            
    
        

    
