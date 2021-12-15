# TidyChaseBankStatements

An R Package for Turning Chase Bank Statements into a Tidyverse-ready dataframe.

Author: [Jae Yeon Kim](https://jaeyk.github.io/)

File an [issue](https://github.com/jaeyk/TidyChaseBankStatements/issues) if you have problems, questions or suggestions. 

## Summary

This R package provides functions to turn a Chase Bank statement (a PDF file) into a tidyverse-friendly dataframe. 

The current version is only able to parse statements from **checking account**. 

You can download bank statements from Chase website (Menu > Statements & documents). The package works for either PDF or accessible PDF files. If one PDF file type does not work, try the other one. 

## Installation

```r

## Install the current development version from GitHub

devtools::install_github("jaeyk/TidyChaseBankStatements", dependencies = TRUE)
```

## Usage

### 1. [`parse_check_statement()`](https://github.com/jaeyk/TidyChaseBankStatements/blob/main/R/parse_check_statement.r): Turn one Chase Bank statement (one PDF file) into a dataframe 

```r
# Apply function 
df <- TidyChaseBankStatements::parse_check_statement(
    file_path = file.choose(), # the Chase Bank Statement PDF file 
    report_year = 2020 # the year in which the statement was reported 
)

```

The parsed output data has a tidy structure. It has eight columns: `(transaction) Date`, `(transaction) Description`, `(transaction) Amount`, `Balance`, `Card` (whether the transaction is related to credit card payment), `Venmo` (whether the transaction is related to Venmo transfers), `Withdraw` (whether the transaction is about withdraw), `Deposit` (whether the transaction is about deposit)

```r
# Examle output (note that this is hypothetical data) 
df[1:5, ]

        Date Description Amount Balance Card Venmo Withdraw Deposit
1 2020-02-24     Netflix     10   10000    1     0        0       1
2 2020-02-24     Grocery    -10   10010    1     0        0       1
3 2020-02-24      Amazon     10   10020    0     1        0       1
4 2020-02-25     Netflix     30   10030    1     0        0       1
5 2020-02-25     Netflix    -10   10040    1     0        0       1
```

## How to cite

If you would like to cite, please do something like the following:

```
Jae Yeon Kim. (2020). TidyChaseBankStatements. R package version 0.1.0. Retrieved from https://github.com/jaeyk/TidyChaseBankStatements
```
