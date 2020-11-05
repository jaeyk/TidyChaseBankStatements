# TidyChaseBankStatements

An R Package for Turning Chase Bank Statements into a Tidyverse-ready Dataframe.

Author: [Jae Yeon Kim](https://jaeyk.github.io/)

File an [issue](https://github.com/jaeyk/TidyChaseBankStatements/issues) if you have problems, questions or suggestions.

## Summary

## Installation

```r

## Install the current development version from GitHub

devtools::install_github("jaeyk/TidyChaseBankStatements", dependencies = TRUE)
```

## Usage

Now, you have a Tweet JSON file or a list of them. Collecting the Tweet JSON file could have has been tedious, especially if you have never done this before. By contrast, turning these files into a tidyverse-ready dataframe is incredibly easy and lightning fast with the help of `tidytweetjson`.

The parsed JSON data has a tidy structure. It has nine columns: (user) `id`, `country_code` (country code), (user) `location`, `created_at` (time stamp), `full_text` (tweets), `retweet_count`, `favorite_count`, `user.followers_count`, and `user.friends_count`. Its rows are tweets.

### 1. `jsonl_to_df()`: Turn a Tweet JSON file into a dataframe

```r

# Load library
library(tidytweetjson)

# You need to choose a Tweet JSON file
filepath <- file.choose()

# Assign the parsed result to the `df` object
df <- jsonl_to_df(filepath)
```

### 2. `parse_check_statement_all()`: Turn all Bank statements, saved in a directory, into a dataframe 

TBD

## How to cite

If you would like to cite, please do something like the following:

```
Jae Yeon Kim. (2020). TidyChaseBankStatements. R package version 0.1.0. Retrieved from https://github.com/jaeyk/TidyChaseBankStatements
```
