This repo began as a final capstone project for the Springboard Data Science Career Track curriculum.  

The project evolved to have two main foci:  
1. Scraping the Steam store to create a relational database-like dataset for various kinds of analysis and modeling
2. Using that data to develop a recommendation engine (recommending games to users based on their profile information)

All code is in the "notebooks" folder. The naming schema is roughly as follows:  
- Notebooks beginning with 0.X are scrapers. As I hadn't learned about threading at the time of scraping, I made many similar copies of notebooks to run simultaneously to achieve "threading" and collect enough data to complete the capstone within a single human lifespan.
- Notebooks 1.1, 2.0, 3.0, and 3.5 are for wrangling, preprocessing, modeling, and a combo prepro/modeling, respectively.

A schema for the collected data and a presentation on the results of the recommendation engine are in "reports".
