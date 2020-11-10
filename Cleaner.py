import pandas as pd

# Cleaning Funda Dataset
housing_Data_test = pd.read_csv("FundaAssignment/Funda_Datasets/housing_data_test.csv",sep=';')

# Cleaning Postcode_Gemeentecode Dataset
postcode_gemeentecode = pd.read_csv("FundaAssignment/CBS_Datasets/CBS_Postcode_Gemeentecode2018.csv",sep=';')
postcode_gemeentecode.drop_duplicates(subset=['PC6'], inplace=True)
postcode_gemeentecode.to_csv("FundaAssignment/CBS_Datasets/CBS_Postcode_Gemeentecode2018_Clean.csv", index=False,sep=';')

