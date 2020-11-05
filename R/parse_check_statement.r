#' Parse a Chase bank statement (saved in an accessible PDF format) into a tidyverse-friendly dataframe 
#'
#' @param file_path A file path which indicates an accessible PDF file that contains Chase bank statement. 
#' 
#' @return A dataframe with four columns ("text", "source", "author", "date")
#' @importFrom tidyr separate
#' @importFrom magrittr "%>%"
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_squish
#' @importFrom stringr str_trim
#' @importFrom xml2 read_html
#' @importFrom purrr map
#' @importFrom purrr reduce
#' @importFrom rvest html_nodes
#' @importFrom rvest html_text
#' @importFrom textclean replace_html
#' @export
#' 

## ---------------------------------------------------------------------------------------------------------
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse, 
               tabulizer,
               purrr,
               glue, 
               here)



## ---------------------------------------------------------------------------------------------------------

file_path <- here("data", "check_statement.pdf")
current_year <- 2020 

parse_check_statement <- function(file_path, current_year){

# Import PDF file and extract table     
if (file.exists(file_path)) {
        
    check_statement <- extract_tables(file = file_path)
        
    } else {stop("File path is wrong.")}
    
if (length(check_statement) == 0) {stop("Something's wrong with extracting a table from the PDF file.")}

## ---------------------------------------------------------------------------------------------------------
# Turn the list of matrices into a dataframe 
df <- map_dfr(check_statement, data.frame)

# Remove the first three rows 
df <- df %>% filter(!str_detect(X1, "TRANSACTION|transaction|DESCRIPTION|Beginning"))

# Create date column 
df <- df %>% 
    mutate(Date = map(X1, ~str_extract(., "^.{1,5}")) %>%
    map_dfr(enframe) %>%
    pull(value)
    ) 
    
# Rename columns 

if (ncol(df) == 4) {
    
    names(df) <- c("Description", "Amount", "Balance", "Date")
    
} else {
    
    # In some cases, unnecessary X2 column is created during the table extracting process.  
    
    df <- df[,-2]
    
    names(df) <- c("Description", "Amount", "Balance", "Date")
    
}

# Add columns 
df$Card <- if_else(str_detect(df$Description, "Card") == TRUE, 1, 0)
df$Venmo <- if_else(str_detect(df$Description, "Venmo") == TRUE, 1, 0)
df$Withdraw <- if_else(str_detect(df$Amount, "-") == TRUE, 1, 0) 
df$Deposit <- if_else(str_detect(df$Amount, "-") != TRUE, 1, 0) 


## ---------------------------------------------------------------------------------------------------------
# Reorder columns; Date comes first 
df <- df %>% relocate(Date)

# Filter Date column by a special character 
df$Date <- if_else(str_detect(df$Date, "/") == TRUE, df$Date, "Not date")

# Filter Date column by data type 
df$Date <- map(df$Date, ~str_extract(., "[:alpha:]")) %>%
    map_dfr(enframe) %>%
    mutate(value = if_else(is.na(value), df$Date, "Not date")) %>%
    pull(value)


## ---------------------------------------------------------------------------------------------------------
# Clean Description column 
df$Description <- if_else(df$Date != "Not date", str_replace_all(df$Description, df$Date, ""), df$Description)

# Filter not-date rows  
df <- df %>% filter(Date != "Not date")

# Remove special characters in Amount and Balance columns 
df <- df %>%
    mutate(
        Amount = str_replace_all(Amount, ",", "") %>% as.numeric(), 
        Balance = str_replace_all(Balance, ",", "") %>% as.numeric()
    )

# Reformat Date variable 

df$Date <- as.Date(glue("{current_year}/{df$Date}"))

return(df)

}