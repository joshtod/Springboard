This repo began as a final capstone project for the Springboard Data Science Career Track curriculum.  

See the "project_overview" file for an introduction to the project.  

The project evolved to have two main foci:  
1. Scraping the Steam store to create a relational database-like dataset for various kinds of analysis and modeling
2. Using that data to develop a recommendation engine (recommending games to users based on their profile information)

All code is in the "notebooks" folder. The naming schema is roughly as follows:  
- Notebooks beginning with 0.X are scrapers. As I hadn't learned about threading at the time of scraping, I made many similar copies of notebooks to run simultaneously to achieve "threading" and collect enough data to complete the capstone within a single human lifespan. (They will not function in their current directory location; I still need to update the filepaths specified in the files.)
- Notebooks 1.1, and 2.0 are for wrangling and prepro/modeling, respectively.

A schema for the collected data and a presentation on the results of the recommendation engine are in "reports".
