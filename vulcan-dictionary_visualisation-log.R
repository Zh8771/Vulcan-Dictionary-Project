##### VULCAN DICTIONARY DATABASE PROJECT - DATA VISUALISATION LOG - GS #####
#### START: 2023.05.04 - LAST UPDATED: 2023.05.04 ####

#### DESCRIPTION OF DATA COLLECTION ####
# Data was collected from the Vulcan Language Institute (VLI) dictionary (archived on the wayback machine)
# and pasted into an Excel file. Excel files were then converted into tab-delimited files and read into R.
# This script is a log of all operations performed on the data after this point.

#### SOURCES ####
# Vulcan-Federation Standard (English) - index: https://web.archive.org/web/20180527014028/http://www.vli-online.org/ohv-eng.htm
# Vulcan affixes: https://web.archive.org/web/20170428102112/http://www.vli-online.org/affixes.htm

### SCRIPT SETUP ###
## Clear R's memory ##
rm(list=ls(all=TRUE))
## LOAD LIBRARIES ##
library(tidyverse)
library(stringr)
library(ggplot2)
library(treemap)
## LOAD DATA ##
V.FSE.new <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/old txt files/V-FSE-pos1.txt", stringsAsFactors=TRUE)


#### ---------- TASK 1: SUBSET DATA TO BE PLOTTED ---------- ####
### So far, the most complete data I have for the V.FSE (Vulcan to Federation Standard English) dataset is for
### the following columns: part of speech, Croftian Crosslinguistic Comparitive Concepts (which I added to be a
### tiny bit more fine-grained than the pos column), and the variety column.

### Some notes on the columns:
## Contained in the part of speech column are the parts of speech contained in the dictionary (where possible),
## as well as my own coding of the values that were missing (the majority of the dictionary entries were missing
## data on the part of speech, so these were coded based on the morphology of the vulcan words and the FSE translations).

## Contained in the Croftian Cross-linguistic Comparitive Concepts column are rough categorisations of the data based on
## Bill Croft's Cross-linguistic Comparitive Concepts (from his 2021 Morphosyntax textbook). In the interests of brevity
## and in order not to have to spend too much time on categorisations, most nouns were labelled as object concepts (OBJ.CONC),
## adjectives as property concepts (PROP.CONC), and verbs as action concepts (ACT.CONC), and small changes were made where applicable.
## Other categorisations present are: Action Concept Modifier (for action concepts doing modification work), Object Concept Modifier
## (For object concepts doing modification work), Predicate Modifier (for Action Concept Modifiers doing predicate work; question words),
## Modal Predicates (for modal action concepts doing predicate work), and Selectional, Situational, and Degree Modifiers (to account for
## modifiers doing deictic and degree work). These are very roughly defined categories and are only meant to paint a slightly more high-
## resolution picture in the plots than I can with the part of speech data.

## Finally, contained in the variety column is information about language variety (lects) contained in the dictionary (where possible),
## as well as my own coding of the values that were missing (given that the dictionary itself was a dictionary of Modern Golic Vulcan, all
## missing values were assumed to be of the majority MGV variety).

### Given that this is the most robust data we have, we'll subset the dataset so that it contains only the columns we need to plot,
### and just enough to give us context...
V.FSE.plot <- subset(V.FSE.new, select = -c(index, pronunciation, misc))

#### ---------- TASK 2: EXPLORE DATA ---------- ####
### Now, out of curiosity, let's get a few counts, here...
### 1. How many Vulcan words of each letter do we have? ###
## Which letters start the most words?
table(V.FSE.plot$FRST_LETTER)
# a   b   d   e   f   g   h   i   k   l   m   n   o   p   r   s   t   u   v   w   y   z 
# 271 111 251 154 171 105 138  70 442 130 236 226  50 210 176 592 487 51 215 130 131 116 

# Looks like the letter 's' wins with 592 observations!

### 2. How many of each part of speech do we have? ###
## Are there more nouns than everything else? Do these distributions tend to match others in actual languages?
table(V.FSE.plot$pos)
# adj.    adv.   conj.  indef. interj.      n.    num.   prep.   pron.      v. 
# 531      60      11       1       9    2925      30      37      36     823 

# Wow, yup. Looks like the category 'noun' wins with 2925 observations, followed by verbs (with 823), then adjectives (with 531).
# This looks a lot like some of the data from the written corpora we worked with last semester in Stats for Linguistics.

### 3. How many of each Cross-ling. Concept do we have? ###
## Which cross-ling concept is more represented? Object concepts?
table(V.FSE.plot$croftian_crossling_concepts)
# ACT.CONC ACT.CONC.MOD CONNECTOR DEG.MOD interjection  OBJ.CONC OBJ.CONC.MOD PREDIC.MOD PREDIC.MODAL PROP.CONC  SELEC.MOD  SITU.MOD 
# 820           50        11      25            9       2942           10            2            5       501    42         46 

# Again, there's still a lot of object concepts in the dictionary (with 2940), followed by action concepts (820), and property concepts (501).
# Getting more fine-grained doesn't seem to change the distribution that much!

### 4. How many of each Variety do we have? ###
## Which cross-ling concept is more represented? Object concepts?
table(V.FSE.plot$variety)
# DONE: (Whoops, found a problem-child (extra tab) in one of my rows (3034)! brb fixing that...)
# DONE: And there are a few things I want to fix in rows 1312, 1414, 2481...
  # 1312: mostly obs. -> obs. (If it's mostly obsolete, we're just going to treat it as obsolete)
  # 1414: TGV/MGV -> lengthened: 1414 = TGV; 1415 = MGV
  # 2482: TGV,LGV -> lengthened: 2482 = TGV; 2483 = MGV
# Okay, now I have to re-run all of my code to catch back up...There we go.
# anc.  LGV  MGV  NGS obs.  TGV 
# 165    2 4209   60   11   16 

# Obviously, Modern Golic Vulcan has the most observations (with 4209; logical, since this **is** an MGV dictionary), and it looks like the
# runner up is the Ancient lect (165), Followed by Non-Golic (loan words) used by speakers of Modern Golic Vulcan (60), Traditional Golic Vulcan
# (or older Golic Vulcan words used in ritual that have not gone out of fashion; 16), obsolete Golic Vulcan terms (or ones that have fallen out
# of fashion; 11), and Lowlands Golic Vulcan (a separate dialect of Golic Vulcan, as opposed to which MGV is the standardised, unmarked dialect;
# 2).


#### ---------- TASK 3: PLOT DATA ---------- ####
### Let's make a few plots of our data! 

### What's the distribution of starting letter counts in the data overall? ###
### Barplot
## It'll be pretty simple to make this barplot out of the data we already have, so let's go for it...
ggplot(V.FSE.plot, aes(x=FRST_LETTER)) +
  geom_bar() +
  theme_classic() +
  xlab("Vulcan - Starting Letters")

# Overall, from this graph, we can see that the letters that start the most Vulcan words are s, t, and k.
# This is probably due to the fact that many Vulcan prefixes start with these letters (there are 4 that
# begin with 't', 9 that begin with 'k', and 15 that begin with 's'). (As a side note, it's interesting 
# that those are all voiceless sounds...I wonder if Golic Vulcans favour words that start with voiceless
# sounds over those that start with voiced sounds?).

### Of the MGV words, what's the distribution of parts of speech counts? ###
## Barplot 
# For this one, I'll have to subset the data a bit, so let's do that first...
V.FSE.plot2 <- V.FSE.plot[V.FSE.plot$variety == "MGV", ]
# Reorder levels so that they're in decreasing order...
V.FSE.plot2$pos <- factor(V.FSE.plot2$pos,                                    
                  levels = c("n.", "v.", "adj.", "adv.", "prep.", "pron.", "num.", "conj.", "interj.", "indef."))
# plot the barplot...
ggplot(V.FSE.plot2, aes(x=pos)) +
  geom_bar() +
  xlab("Modern Golic Vulcan - parts of speech")

### Okay that's cool, but there's so many nouns that it's hard to see everything else! Let's try this on a log scale so it's easier to see...
ggplot(V.FSE.plot2, aes(x=pos)) +
  geom_bar() +
  scale_y_continuous(trans = 'log2') +
  xlab("Modern Golic Vulcan - parts of speech")

## Just for fun, why don't we try a tree map instead?
## Treemap
# To make a treemap, we'll need a data frame that has our counts in it
V.FSE.plot3 <- data.frame(table(V.FSE.plot2$pos))
# Now we can plot it
treemap(V.FSE.plot3,
        index="Var1",
        vSize="Freq",
        type="index",
        palette = "Set1",
        title="Relative Amounts of each Part of Speech in MGV",
        fontsize.title=12,    
)

# Again, still hard to see the indefinite article, but it's cool to see how many nouns there are as opposed to other things in the data set!

### How many of the NGS (borrowed) words are object concepts? ###
## I expect it to be almost 100% (if not exactly 100%)...let's go with a pie chart for funsies.
V.FSE.plot4 <- V.FSE.plot[V.FSE.plot$variety == "NGS", ]
# let's make a prop.table (proportions table) of the crossling concepts for this so we can actually plot it...
V.FSE.plot5 <- data.frame(prop.table(table(V.FSE.plot4$croftian_crossling_concepts)))
# Oh this is gonna be bad/funny...
pie(V.FSE.plot5$Freq, labels = V.FSE.plot5$Var1, main = "Percentage of object concepts of NGS Borrowed words")
# HAHAHA yup. There it is! Almost 100% of the NGS words are object concepts. This follows Croft's established universal that object concepts
# are the easiest to borrow!

### Okay, for real tho. Let's compare the NGS words with the ancient ones ###
## Bar graph
V.FSE.plot6 <- V.FSE.plot[V.FSE.plot$variety == "NGS" | V.FSE.plot$variety == "anc.", ]
V.FSE.plot7 <- V.FSE.plot6 %>% 
  count(variety, croftian_crossling_concepts) %>%
  mutate(Freq = n/sum(n))
V.FSE.plot7$croftian_crossling_concepts <- factor(V.FSE.plot7$croftian_crossling_concepts,                                    
                          levels = c("OBJ.CONC", "ACT.CONC", "PROP.CONC", "interjection", "ACT.CONC.MOD"))
# Let's do a grouped bar graph...
ggplot(V.FSE.plot7, aes(x=croftian_crossling_concepts, y=n, fill=variety))+  
  geom_bar(position="dodge", stat="identity") + 
  theme_classic() + 
  labs(title = "Comparison of Crosslinguistic Concept Counts b/w Ancient Golic Vulcan and NGS", x = "Crosslinguistic Concepts", y = "", fill="Type")+  
  scale_fill_discrete(name= "Type")

# Hard to see, but it looks like a lot more Ancient Golic Vulcan words have stuck around than the borrowed ones.
# Let's try logging this y axis, too...
ggplot(V.FSE.plot7, aes(x=croftian_crossling_concepts, y=n, fill=variety))+  
  geom_bar(position="dodge", stat="identity") + 
  scale_y_continuous(trans = 'log2') +
  theme_classic() + 
  labs(title = "Comparison of Crosslinguistic Concept Counts b/w Ancient Golic Vulcan and NGS", x = "Crosslinguistic Concepts", y = "", fill="Type")+  
  scale_fill_discrete(name= "Type")

### Back to the starting letters...
## I think I found the first bar graph to be the most interesting, so let's try to add some colour to that one.

## I'd like to compare MGV With Ancient and see which ones have  
V.FSE.plot8 <- V.FSE.plot[V.FSE.plot$variety == "MGV" | V.FSE.plot$variety == "anc.", ]
V.FSE.plot9 <- V.FSE.plot8 %>% 
  count(variety, FRST_LETTER) %>%
  mutate(Freq = n/sum(n))

ggplot(V.FSE.plot9, aes(x=FRST_LETTER, y=n, fill=variety))+  
  geom_bar(position="dodge", stat="identity") + 
  theme_classic() + 
  labs(title = "Starting Letters in Modern Golic vs. Ancient Vulcan", x = "Crosslinguistic Concepts", y = "", fill="Type")+  
  scale_fill_discrete(name= "Type")
# hmm...the barplot is hard to see! Let's try getting percentages instead...
ggplot(V.FSE.plot9, aes(x=FRST_LETTER, y=n, fill=variety))+  
  geom_bar(position="fill", stat="identity") + 
  theme_classic() + 
  labs(title = "Starting Letters in Modern Golic vs. Ancient Vulcan", x = "Crosslinguistic Concepts", y = "", fill="Type")+  
  scale_fill_discrete(name= "Type")
# Still really hard to see. Let's look at just the Ancient data...
V.FSE.plot10 <- V.FSE.plot[V.FSE.plot$variety == "anc.", ]
ggplot(V.FSE.plot10, aes(x=FRST_LETTER)) +
  geom_bar() +
  theme_classic() +
  xlab("Ancient Vulcan - Starting Letters")
# It looks like their winner is k instead of s (as it was for MGV)! It still looks like they favour voiceless starting sounds  
# overall and the winning letters are still s, t, and k.

## So now I want to know if Modern Golic and Ancient Vulcan really do show a preference for starting with voiceless sounds,
## and what the difference is between them.

# What happens when we log the y axis for both Modern Golic and Ancient?
ggplot(V.FSE.plot9, aes(x=FRST_LETTER, y=n, fill=variety))+  
  geom_bar(position="dodge", stat="identity") + 
  theme_classic() + 
  scale_y_continuous(trans = 'log2') +
  labs(title = "Starting Letters in Modern Golic vs. Ancient Vulcan", x = "Crosslinguistic Concepts", y = "", fill="Type")+  
  scale_fill_discrete(name= "Type")

# This is easier to see, but it doesn't really tell me anything. Oh well.

# Out of curiosity, I'm going to add another column to V.FSE.plot9 that includes whether the starting letter is voiced or not...(this will be easier to do in excel)
write.table(V.FSE.plot9, file = "V-FSE-plot9.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)
# Read table back in...
V.FSE.plot8 <- read.delim("~/590DataScience/Vulcan-Dictionary-Project1/V-FSE-plot8.txt", stringsAsFactors=TRUE)
# I want words instead of numbers, so I'm going to redo the voicing column...
V.FSE.plot9 <- V.FSE.plot8 %>%
  mutate(voicing = if_else(voicing == 1, "voiced", "voiceless"))

# This isn't what I expected to see, but I think it may be my inexperience with plotting that is making it hard for me
# to figure out how to connect the voicing counts with the plot itself...

ggplot(V.FSE.plot8, aes(x=voicing, fill = variety)) +
  geom_bar(position="dodge", stat = "count") +
  scale_y_continuous(trans = 'log2') +
  theme_classic() +
  xlab("Voicing of Starting Letters in Modern Golic vs. Ancient Vulcan")

# Hmm...those look exactly the same? Oh well. We're out of time, so we'll figure it out later.

# Ah! In order to meet the requirements of the assignment, I will write the table I've been working on as a csv!
write.table(V.FSE.plot9, file = "V-FSE-plot9.csv", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

### END ###
