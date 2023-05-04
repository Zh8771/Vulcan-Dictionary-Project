##### VULCAN DICTIONARY DATABASE PROJECT - DATA CURATION LOG - GS #####
#### START: 2023.04.11 - LAST UPDATED: 2023.05.03 ####

#### DESCRIPTION OF DATA COLLECTION ####
# Data was collected from the Vulcan Language Institute (VLI) dictionary (archived on the wayback machine)
# and pasted into an Excel file. Excel files were then converted into tab-delimited files and read into R.
# This script is a log of all operations performed on the data after this point.

#### SOURCES ####
# Vulcan-Federation Standard (English) - index: https://web.archive.org/web/20180527014028/http://www.vli-online.org/ohv-eng.htm
# Federation Standard (English)-Vulcan - index: https://web.archive.org/web/20180427031114/http://www.vli-online.org/eng-ohv.htm
# Vulcan-Klingon - dictionary: https://web.archive.org/web/20160729005845/http://www.vli-online.org/gv-kli.htm
# Tutorial for splitting combined column: https://stackoverflow.com/questions/44544776/extract-rows-from-a-single-column-to-form-two-new-columns 
# Tutorial for IF-ELSE/FOR/WHILE loops in R: https://www.dataquest.io/blog/control-structures-in-r-using-loops-and-if-else-statements/

### SCRIPT SETUP ###
## Clear R's memory ##
rm(list=ls(all=TRUE))
## Define function trim() to remove excess leading or trailing spaces in columns
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
trim1 <- function (x) gsub("^NA|NA$", "", x)
trim2 <- function (x) gsub("^;|;$","", x)
## LOAD LIBRARIES ##
library(stringr)
library(tidyverse)
## LOAD DATA ##
# Vulcan-Federation Standard (English) Dictionary:
V.FSE <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/V-FSE-raw.txt", stringsAsFactors=TRUE)
# Federation Standard (English)-Vulcan Dictionary:
FSE.V <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/FSE-V-raw.txt", stringsAsFactors=TRUE)
# Vulcan-Klingon Dictionary:
V.KLI <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/V-KLI-raw.txt", stringsAsFactors=TRUE)


#### ---------- TASK 1: CLEAN UP RAW DATA ---------- ####
# This task was performed to separate the Vulcan words from their metalanguages (Federation Standard, Klingon)
# into two separate columns, remove leading and trailing spaces, and save the resulting tables

# Before I do anything else, I'd like to get rid of the leftover <ca> html tags that are in the data, because they cause issues when I try to run my code!
V.FSE$WORD.V <- gsub('<ca>','',V.FSE$WORD.V)
FSE.V$WORD.FSE <- gsub('<ca>','',FSE.V$WORD.FSE)
V.KLI$WORD.V <- gsub('<ca>','',V.KLI$WORD.V)
# NOTE: Beware! Putting square brackets around the first argument of 'gsub' acts as a 'contains' clause and will take out anything contained within the brackets
# For example gsub('[<ca>]'... takes out anything with '<', anything with 'c', anything with 'a', and anything with '>'.

#### START WITH VULCAN-FSE DICTIONARY ####
# Hmm, I have old code, but let's try to simplify this a little, shall we?
V.FSE <- data.frame(V.FSE) %>%
  separate(WORD.V,
           into = c("vulcan", "fse"),
           sep = "--")
# DONE: I got an error message that row 627 (in $fse) is empty (NA). I'll go back and fix that in the data so it won't mess up the code.

# WOOO I don't need this old code anymore HALLELUJAH (I'm keeping it though, because this code helps you see the steps)
  # Step 1:  Split word/meaning column into two separate columns, store as a data frame for ease of merging back into the full dataset
  # V.FSE1 <- data.frame(str_split_fixed(V.FSE$WORD.V, '--', 2))
  # Step 2: combine columns of new data frame with original
  # V.FSE2 <- cbind(V.FSE, V.FSE1)
  # Step 3: take out word.v and rename columns
  # V.FSE3 <- subset(V.FSE2, select = -WORD.V)
  # V.FSE <- V.FSE3 %>% 
  #   rename("vulcan" = "X1",
  #          "fse" = "X2")
  # Step 4: trim extra spaces
  # V.FSE$fse <- trim(V.FSE$fse)
  # V.FSE$vulcan <- trim(V.FSE$vulcan)
  # Remove excess tables
  # rm(V.FSE1, V.FSE2, V.FSE3)

# Save resulting table in wd (working directory)
write.table(V.FSE, file = "V-FSE-sep.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

#### REPEAT FOR FSE-VULCAN DICTIONARY ####
# Hmm, I have old code, but let's try to simplify this a little, shall we?
  # FSE.V <- data.frame(FSE.V) %>%
  #   separate(WORD.FSE,
  #            into = c("fse", "vulcan"),
  #            sep = "--")
# So this didn't work for some reason. (Error message: "Error in nchar(u, itype) : invalid multibyte string, element 1")
# Let's use our old code for now...

  # Step 1:  Split word/meaning column into two separate columns, store as a data frame for ease of merging back into the full dataset
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

# Save resulting table in wd (working directory)
write.table(FSE.V, file = "FSE-V-sep.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

#### REPEAT FOR KLINGON DICTIONARY ####
# Hmm, I have old code, but let's try to simplify this a little, shall we?
V.KLI <- data.frame(V.KLI) %>%
  separate(WORD.V,
           into = c("vulcan", "klingon"),
           sep = "--")

# WOOO I don't need this old code anymore HALLELUJAH (I'm keeping it though, because this code helps you see the steps)
  # Step 1:  Split word/meaning column into two separate columns, store as a data frame for ease of merging back into the full dataset
  # V.KLI1 <- data.frame(str_split_fixed(V.KLI$WORD.V, '--', 2))
  # Step 2: combine columns of new data frame with original
  # V.KLI2 <- cbind(V.KLI, V.KLI1)
  # Step 3: take out word.v and rename columns
  # V.KLI3 <- subset(V.KLI2, select = -WORD.V)
  # V.KLI <- V.KLI3 %>% 
  #   rename("vulcan" = "X1",
  #          "klingon" = "X2")
  # Step 4: trim extra spaces
  # V.KLI$vulcan <- trim(V.KLI$vulcan)
  # V.KLI$klingon <- trim(V.KLI$klingon)
  # Remove excess tables
  # rm(V.KLI1, V.KLI2, V.KLI3)

# Save resulting table in wd (working directory)
write.table(V.KLI, file = "V-KLI-sep.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

#### This next section is also old, because I figured out some work-arounds for these issues! Keeping my notwes for posterity, tho! ####
  ### REMOVE UNWANTED CHARACTERS & FORMATTING FROM V.FSE, FSE.V ###
  ## NOTE: This section does not apply to the V.KLI data as it did not exhibit these issues.
  # Because the data was copied and pasted from a capture of a web page, there were html tags
  # and characters such as "<ca>" "�" and "\" leftover in the data after we separated it out.
  # Since these will make it harder for us to manipulate the data further and separate out all
  # of the useful bits of info, let's change or get rid of these. 

  ## Step 1: Replace backslashes with forward slashes
  # I still want to keep the slashes in the data because they delimit some (albeit incomplete)
  # pronunciation data that I want to keep. However, I had to manipulate the data in excel to get
  # rid of the backslashes because they're a special operator in R and they would have interfered
  # with the code if I tried to replace them here, so the steps in this subsection were completed
  # in Excel with the 'find and replace' function.

  ## Step 2: Get rid of html tags & extra formatting
  # I also used the 'find and replace' function to get rid of the "<ca>" tags and then used the
  # 'erase formatting' function to get rid of the "�" characters, as my professor and I think they
  #  were formatting instructions to make things italicised (although we could be wrong).
  # NOTE: The <ca> tags were replaced by "--" so that the information in the parentheses following
  # it could be extracted more easily by adapting previously used code.

  # Now we'll read the new manipulated data back into R... (frmtd = formatted)
  # V.FSE.frmtd <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/V-FSE-frmtd.txt", stringsAsFactors=TRUE)
  # FSE.V.frmtd <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/FSE-V-frmtd.txt", stringsAsFactors=TRUE)

  ## Step 3: Hmm...those weren't there before...
  # The first thing I noticed about FSE.V.frmtd is that there are new <ca> tags around the parentheses
  # I'll try to get rid of them here in R...
  # V.FSE.frmtd$vulcan <- gsub('[<ca>]','',V.FSE.frmtd$vulcan)
  # FSE.V.frmtd$fse <- gsub('[<ca>]','',FSE.V.frmtd$fse)

  ## Okay, great! So that code removes the need for this old code because the "�" isn't showing up! *phew*
    # FSE.V.frmtd %>% 
    #   mutate_all(funs(str_replace(., "<ca>", "--")))
    # FSE.V.frmtd %>% 
    # Oof running this creates new "�" thingies...Let's try a similar way to get rid of them...
    #   mutate_all(funs(str_replace(., "�", "--")))
    # Now let's trim off that pesky "�"!!
    # FSE.V.frmtd$fse <- trim1(FSE.V.frmtd$fse)

    # Let's try it on V.FSE...
    # V.FSE.frmtd <- V.FSE.frmtd %>% 
    #   mutate_all(funs(str_replace(., "<ca>", "--")))
    # V.FSE.frmtd <- V.FSE.frmtd %>% 
    #   mutate_all(funs(str_replace(., "�", "--")))
    # V.FSE.frmtd$vulcan <- trim1(V.FSE.frmtd$vulcan)


#### ---------- TASK 2: WIDEN, LENGTHEN DATA ---------- ####
### There are many different pieces of information still in the cells for these dictionaries, so
### in keeping with tidy data principles, let's separate out some of the information in the columns
### Tasks: Add columns for pronunciation, part of speech (pos), variety (e.g. ancient, MGV, TGV, etc.),
### and domain (legal, medical, geological...etc.); (and we might add some morphology columns for the 
### Vulcan words, if there's time)

### First, we'll separate out variety data and add the 'variety' column to V.FSE ###
## We have to do this one first because the variety data is at the end of the string in the cells that have them
V.FSE1 <- data.frame(V.FSE) %>%
  separate(vulcan,
           into = c("vulcan", "variety"),
           sep = "\\(|\\)")
# This is promising, because it seems to have worked! Now we'll need to replace the NAs with MGV (Modern Golic Vulcan),
# since this is a Modern Golic dictionary, and where variety was not specified, it was understood to be MGV, so we want
# our data to reflect this.
V.FSE1$variety <- V.FSE1$variety %>% replace_na('MGV')

### Next, we'll Separate out (incomplete) pronunciation data from V.FSE ###
# NOTE: The writers of the dictionary attempted to add pronunciations to some of the words;
# Not all words in the dictionary have pronunciation data, but the ones that do are often
# incomplete due to the snapshot on the wayback machine inadequately capturing the unicode.
# Thus, original data on pronunciation is spotty at best, but can be reconstructed from the
# pronunciation guide in the language lessons (I will create a new column for these; the data 
# will remain incomplete until I have time to fix them. When I do, I will do that in excel)

# We're doing this next to isolate the Vulcan words from their pronunciations, which are now the last thing in the string in the cells that contain them
# Step 1:  Split word/pronunciation column into two separate columns, store as a data frame for ease of merging back into the full dataset
# Hmm, I have old code, but let's try to simplify this a little, shall we?
V.FSE2 <- data.frame(V.FSE1) %>%
  separate(vulcan,
           into = c("vulcan", "pronunciation"),
           sep = "\\\\")

# WOOO I don't need this old code anymore HALLELUJAH (I'm keeping it though, because this code helps you see the steps)
  # V.FSE2 <- data.frame(str_split_fixed(V.FSE1$vulcan, '\\/|\\/', 2))
  # Step 2: combine columns of new data frame with original
  # V.FSE3 <- cbind(V.FSE1, V.FSE2)
  # Step 3: take out word.v and rename columns
  # V.FSE4 <- subset(V.FSE3, select = -vulcan)
  # V.FSE <- V.FSE4 %>% 
  #   rename("vulcan" = "X1",
  #          "pronunciation" = "X2")
  # Step 4: reorder the columns
  # V.FSE <- V.FSE[, c("FRST_LETTER", "vulcan", "variety", "pronunciation", "fse")]
  # Remove excess tables
  # rm(V.FSE1, V.FSE2, V.FSE3, V.FSE4, V.FSE.frmtd)
  # Step 4: Save resulting table in wd (working directory)
  # write.table(V.FSE, file = "V-FSE-var.txt", append = FALSE, sep = "\t", dec = ".",
  #             row.names = TRUE, col.names = TRUE)

### Next, we'll separate out part of speech data and add the 'part of speech (pos)' column to V.FSE, FSE.V ###
## This has proven to be quite the challenge so let's start with the easy part first.
# Get the data in parentheses into a separate column (V.FSE)
V.FSE <- data.frame(V.FSE2) %>%
  separate(fse,
      into = c("fse", "domain"),
      sep = "\\(|\\)")
# Remove excess tables (I only have these excess tables in the first place so I can go back and change something without starting all the way over!)
rm(V.FSE1,V.FSE2)

# Save resulting table in wd (working directory)
write.table(V.FSE, file = "V-FSE-var.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

# Get the data in parentheses into a separate column (FSE.V)
FSE.V <- data.frame(FSE.V) %>%
  separate(fse,
           into = c("fse", "domain"),
           sep = "\\(|\\)")

# Save resulting table in wd (working directory)
write.table(FSE.V, file = "FSE-V-var.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

# Now, since there are some parentheses in the V.KLI data, let's separate those out, too
# Get the data in parentheses into a separate column (FSE.V)
V.KLI <- data.frame(V.KLI) %>%
  separate(vulcan,
           into = c("vulcan", "domain"),
           sep = "\\(|\\)")
# Interesting, there's an 'adv.' in there!
# We'll have to separate those out, but that's a later-us problem.

# Save resulting table in wd (working directory)
write.table(V.KLI, file = "V-KLI-var.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

### Now, we need to separate out the values in the new columns ###
## What happened when we ran the part of the code immediately above is that the domain data and the part of speech data were put into same column, so now we have to separate those out
## Now what I'm trying to do is make a separate column with only the part of speech data in it (of which only adjectives,
## nouns, prepositions, and verbs are marked). Since the column that gets created when I run the separation consists
## of more than just the part of speech data, I need to separate rows that have one of the parts of speech into one
## column, and the rest of the rows into a separate column.

## Step 1: Separate out the domain and extra material from the pos column, V.FSE
# Let's try separating the column by comma first, just so that there's not more than one value in each cell...
V.FSE1 <- data.frame(V.FSE) %>%
  separate(domain,
           into = c("misc", "secondary.domain"),
           sep = ",")

# Let's give this the good ol' college try...
  # V.FSE1 <- data.frame(V.FSE, stringsAsFactors = T) %>%
  #  add_column(pos = if_else(value %in% .$domain,
  #    contains("adj.") ~ "adjective",
  #    contains("n.") ~ "noun",
  #    contains("prep.") ~ "preposition",
  #    contains("v.") ~ "verb"))
# Nope. That didn't work. Let's try something else.

# First, let's create a vector that has our expected parts of speech in it...
v1 <- c('adj.', 'n.', 'prep.', 'v.')
# Then, let's see if we can get it to break up the two columns
V.FSE2 <- V.FSE1 %>%
  group_by(grp = c('domain', 'pos')[(misc %in% v1) + 1]) %>%
  mutate(n = row_number())  %>%
  spread(grp, misc) %>% 
  select(-n)
# Okay! This worked to get the parts of speech into a single column! Which is great, but now I have to go recode the ones that have no data for them in Excel. .-.

# Before I do that, let's see if I can recombine the domain & secondary domain columns so I can later separate out what is an abbreviation, what is an extension,
# and what is an actual semantic domain!
V.FSE2 <- V.FSE2[, c("FRST_LETTER", "vulcan", "pronunciation", "variety", "pos", "fse", "domain", "secondary.domain")]
V.FSE2$misc <- paste(V.FSE2$secondary.domain, V.FSE2$domain, sep=";")
V.FSE <- subset(V.FSE2, select = -c(domain,secondary.domain))
V.FSE$misc <- trim(V.FSE$misc)
# Let's get rid of the printed NAs in there...
V.FSE$misc <- trim1(V.FSE$misc)
# Now let's trim off the ; if it's at the beginning of the 'misc' column...
V.FSE$misc <- trim2(V.FSE$misc)
# NOTE TO SELF: When editing in Excel, line 209 has an extra tab after pos column that needs deleted!

# Let's write a new table we can edit in text editor/excel!
write.table(V.FSE, file = "V-FSE-pos.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)


### Next, we'll separate out semantic domain data and add the 'domain' column to V.FSE, FSE.V ###

#### TASK 3: (if there's time) Add concept data from concepticon, new Vulc-concepticon ####
# Vulc-concepticon = new table I will create with vulcan-specific and trek-specific concepts
