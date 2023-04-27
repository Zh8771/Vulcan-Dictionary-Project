##### VULCAN DICTIONARY DATABASE PROJECT - DATA CURATION LOG - GS #####
#### START: 2023.04.11 - LAST UPDATED: 2023.04.13 ####

#### DESCRIPTION OF DATA COLLECTION ####
# Data was collected from the Vulcan Language Institute (VLI) dictionary (archived on the wayback machine)
# and pasted into an Excel file. Excel files were then converted into tab-delimited files and read into R.
# This script is a log of all operations performed on the data after this point.

#### SOURCES ####
# Vulcan-Federation Standard (English) - index: https://web.archive.org/web/20180527014028/http://www.vli-online.org/ohv-eng.htm
# Federation Standard (English)-Vulcan - index: https://web.archive.org/web/20180427031114/http://www.vli-online.org/eng-ohv.htm
# Vulcan-Klingon - dictionary: https://web.archive.org/web/20160729005845/http://www.vli-online.org/gv-kli.htm

### SCRIPT SETUP ###
## Clear R's memory ##
rm(list=ls(all=TRUE))
## Define function trim() to remove excess leading or trailing spaces in columns
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
## LOAD LIBRARIES ##
library(stringr)
library(tidyverse)
## LOAD DATA ##
# Vulcan-Federation Standard (English) Dictionary:
V.FSE <- read.delim("~/590DataScience/vulcan-dictionary/V-FSE-raw.txt", stringsAsFactors=TRUE)
View(V.FSE)
# Federation Standard (English)-Vulcan Dictionary:
FSE.V <- read.delim("~/590DataScience/vulcan-dictionary/FSE-V-raw.txt", stringsAsFactors=TRUE)
View(FSE.V)
# Vulcan-Klingon Dictionary:
V.KLI <- read.delim("~/590DataScience/vulcan-dictionary/V-KLI-raw.txt", stringsAsFactors=TRUE)
View(V.KLI)


#### ---------- TASK 1: CLEAN UP RAW DATA ---------- ####
# This task was performed to separate the Vulcan words from their metalanguages (Federation Standard, Klingon)
# into two separate columns, remove leading and trailing spaces, and save the resulting tables

#### START WITH VULCAN-FSE DICTIONARY ####
# STEP 1:  Split word/meaning column into two separate columns
V.FSE1 <- data.frame(str_split_fixed(V.FSE$WORD.V, '--', 2))
# Step 2: combine columns of new data frame with original
V.FSE2 <- cbind(V.FSE, V.FSE1)
# Step 3: take out word.v and rename columns
V.FSE3 <- subset(V.FSE2, select = -WORD.V)
V.FSE <- V.FSE3 %>% 
  rename("vulcan" = "X1",
         "fse" = "X2")
# Step 4: trim extra spaces
V.FSE$fse <- trim(V.FSE$fse)
V.FSE$vulcan <- trim(V.FSE$vulcan)
# Remove excess tables
rm(V.FSE1, V.FSE2, V.FSE3)
# Step 4: Save resulting table in wd (working directory)
write.table(V.FSE, file = "V-FSE-sep", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

#### REPEAT FOR FSE-VULCAN DICTIONARY ####
# STEP 1:  Split word/meaning column into two separate columns
FSE.V1 <- data.frame(str_split_fixed(FSE.V$WORD.FSE, '--', 2))
# Step 2: combine columns of new data frame with original
FSE.V2 <- cbind(FSE.V, FSE.V1)
# Step 3: take out word.v and rename columns
FSE.V3 <- subset(FSE.V2, select = -WORD.FSE)
FSE.V <- FSE.V3 %>% 
  rename("fse" = "X1",
         "vulcan" = "X2")
# Step 4: trim extra spaces
FSE.V$vulcan <- trim(FSE.V$vulcan)
FSE.V$fse <- trim(FSE.V$fse)
# Remove excess tables
rm(FSE.V1, FSE.V2, FSE.V3)
# Step 4: Save resulting table in wd (working directory)
write.table(FSE.V, file = "FSE-V-sep", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

#### REPEAT FOR KLINGON DICTIONARY ####
# STEP 1:  Split word/meaning column into two separate columns
V.KLI1 <- data.frame(str_split_fixed(V.KLI$WORD.V, '--', 2))
# Step 2: combine columns of new data frame with original
V.KLI2 <- cbind(V.KLI, V.KLI1)
# Step 3: take out word.v and rename columns
V.KLI3 <- subset(V.KLI2, select = -WORD.V)
V.KLI <- V.KLI3 %>% 
  rename("vulcan" = "X1",
         "klingon" = "X2")
# Step 4: trim extra spaces
V.KLI$vulcan <- trim(V.KLI$vulcan)
V.KLI$klingon <- trim(V.KLI$klingon)
# Remove excess tables
rm(V.KLI1, V.KLI2, V.KLI3)
# Step 4: Save resulting table in wd (working directory)
write.table(V.KLI, file = "V-KLI-sep", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

#### ---------- TASK 2: WIDEN, LENGTHEN DATA ---------- ####
### There are many different pieces of information still in the cells for these dictionaries, so
### in keeping with tidy data principles, let's separate out some of the information in the columns
### Tasks: Add columns for pronunciation, part of speech (pos), variety (e.g. ancient, MGV, TGV, etc.),
### and domain (legal, medical, geological...etc.); (and we might add some morphology columns for the 
### vulcan words, if there's time)

## STEP 1: First, we'll Separate out (incomplete) pronunciation data from V.FSE
# NOTE: The writers of the dictionary attempted to add pronunciations to some of the words;
# Not all words in the dictionary have pronunciation data, but the ones that do are often
# incomplete due to the snapshot on the wayback machine inadequately capturing the unicode.
# Thus, original data on pronunciation is spotty at best, but can be reconstructed from the
# pronunciation guide in the language lessons (I will create a new column for these; the data 
# will remain incomplete until I have time to fix them. When I do, I will do that in excel)

## STEP 2: Next, we'll add the 'part of speech (pos)' column to V.FSE, FSE.V


## STEP 3: Next, we'll add the 'variety' column to V.FSE, FSE.V


## STEP 4: Next, we'll add the 'domain' column to V.FSE, FSE.V


#### TASK 4: (if there's time) Add concept data from concepticon, new Vulc-concepticon ####
# Vulc-concepticon = new table I will create with vulcan-specific and trek-specific concepts
