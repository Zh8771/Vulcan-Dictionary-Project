# Vulcan-Dictionary-Project
## This is a repository for a Vulcan Dictionary Database Class project

This repository is for the files and code I'm using to create a relational Vulcan Dictionary database (this is for a Linguistics Data Science class).
Disclaimer: I am new to coding and to github, so please bear with me!

The Data for this project was obtained from the Vulcan Language Institute (VLI) dictionary (archived on the wayback machine) and is based on Mark Gardner's (and colleagues') work on the Vulcan Language from the Star Trek television show franchise. The data was pasted into an Excel file, which was then then converted into a tab-delimited file and read into R.

Initially, the project will be small-scale, because I only have less than a week to complete the assignment, so it will only contain the Vulcan-Federation Standard (English) dictionary. Also, given that this data was collected for a linguistics project, this data will be curated according to tidy data principles, which means it will not appear in the same format that it did on the VLI website (e.g., I will be separating out information about pronunciation, part of speech...etc.). Eventually, I hope to expand this project to include more of the dictionaries hosted on the VLI website, but I am just one person and I am new to coding, so this may take quite a long time (any suggestions or tips would be greatly appreciated).=

All of that said, I don't mean to step on anyone's toes. This project is being done out of a passion for the preservation of all the work done on the Vulcan language, and I realise that the work done has been a group effort--an effort that I was not involved in. I came into everything very late, when the VLI only existed on the wayback machine, so I only have a small idea of the immense amounts of work that have gone into the project before now. As a linguistics graduate student, my only intention is to add my own part to all the work that was done before, and insodoing, preserve it for future generations.

### What I have done so far...
I tried to curate the data according to tidy data principles, (e.g., I tried to separate out information about pronunciation, part of speech...etc.). This turned out to be much more involved than I was originally expecting, but I did learn a lot about various ways to expand out data that was not compiled according to tidy data principles and ways for solving difficult coding problems (a process which you can read further about in the comments of the data curation log R script, if you so desire).

I originally started out with three datasets: The Vulcan-Federation Standard (English) dictionary (listed as V.FSE, with ~4460 entries), the Federation Standard (English)-Vulcan dictionary (listed as FSE.V, with ~16400 entries), and the Vulcan-Klingon dictionary (listed as V.KLI, with ~560 entries). I wanted to choose a dataset with enough data for this project, so I chose the middle-ground Vulcan-Federation Standard (English) dictionary, separated out what data I could, added some extra coding, and worked on a way to visualise it (for full details on data visualisation, you can view the data visualisation log R script).

