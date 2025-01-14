/* 
 2.03 Activity 1
 Keep working on the bank database. (In case you need to load data again, refer to the previous lab and files_for_lab folder to get the database.)
 
 Queries:
 */
/* 
 1) Get card_id and year_issued for all gold cards.
 */
SELECT
  card_id,
  LEFT(issued, 2) AS year_issued
FROM
  card
WHERE
  TYPE = 'gold';

/* 
 2) When was the first gold card issued? (Year)
 */
SELECT
  TYPE,
  MIN(issued) AS first_gold_card_issued
FROM
  card
WHERE
  TYPE = 'gold';

/* 
 3) Get issue date as:
 
 date_issued: 'November 7th, 1993'
 fecha_emision: '07 of November of 1993'
 */
/*
 Note: Changing data type of the column "issued" in the "card" table
 which stores dates with 2-digit years. 
 Date values with 2-digit years are ambiguous because the century is unknown.
 
 */
/*Prepended the characters "19" at the bigining 
 of the year to make it a 4 digit year format.
 */
UPDATE
  card
SET
  issued = Concat('19', issued);

/* 
 Uptating the records of the column "issued" to a DATETIME format
 that MySQL can understand as YYY-MM-DD hh:mm:ss
 */
UPDATE
  card
SET
  issued = date_format(
    str_to_date(issued, '%Y%m%d %H:%i:%s'),
    '%Y-%m-%d %H:%i:%s'
  );

/* 
 Altereing the data type of the column to datetime
 */
ALTER TABLE
  card
MODIFY
  issued datetime;

/* 
 date_issued: 'November 7th, 1993'
 */
SELECT
  date_format(issued, '%M %D, %Y ') AS date_issued
FROM
  card;

/*
 fecha_emision: '07 of November of 1993'
 */
SELECT
  date_format(issued, '%d of %M of %Y') AS fecha_emision
FROM
  card;

/* 
 2.03 Activity 3
 Questions and queries:
 
 1) Null or empty values are usually a problem. Think about why those null values can 
 appear and think of ways of dealing with them.
 
 I think NULL values are rather than a probles, just a slight inconvenience. 
 It is true that when carrzing out EDA, it is better and in most cases necesarz to have a clean dataset 
 free of nulls. 
 
 We have plent of tools to deal with null values. Whether thez should be erradicated 
 entirelz from the dataset should be treated in a case bz case bases, depending on the tzpe of
 analiszs we are trzing to make.
 
 From the perspective of database normalization, nulls are frowned upon. The rationale being that 
 if a value can be nothing, then you should split it out into another sparse table so that you don't
 have to hold rows for items with no worth. 
 
 It's an effort to ensure that all information is valid and meaningful. 
 Having a null field in some circumstances may be advantageous, especially when seeking to minimize the number of joins (
 although this shouldn't be an issue unless the database engine is configured correctly).
 
 Answer: Null values appear for three reasons: data was not recorded, an unknown value (such as a parameter to a function), and the result of divide by zero.
 
 Nulls are one of the most difficult things in SQL because SQL doesn't have a "none" symbol
 to represent these values. Because nulls are often used when there is no more information 
 or on input parameters, where the user has left some amount of information blank, it becomes 
 very hard to represent "nothing".
 
 When dealing with null values in SQL there are three possible approaches that can be taken: 
 Ignore them, if you do not need any semantics associated with their existence; replace them, 
 by assigning a default value such as NULL in place of the missing column in your queries; and 
 having them evaluate methods to differentiate whether it evaluates true or false i.e. ISNULL().
 
 */
/* 
 2) Check for transactions with null or empty values for the column amount.
 */
SELECT
  amount
FROM
  trans
WHERE
  amount IS NULL;

SELECT
  count(amount)
FROM
  trans
WHERE
  amount = '';

SELECT
  count(amount)
FROM
  trans
WHERE
  amount IS NULL
  OR amount = '';

/* 
 3) Count how many transactions have empty and non-empty k_symbol (in one query).
 */
/*
 # To check my solution, I count the total number of records I have on the column k_symbol
 */
SELECT
  count(k_symbol)
FROM
  trans;

# I have a total of 868.019 rows.
/* 
 Now I count how many transactions have empty and 
 non-empty in the table k_symbol (in one query)
 
 In this case I use the sum() function instaead of count() to 
 see the total of transactions with empty or not empty rows.
 Then I filter the result for null values
 */
SELECT
  sum(k_symbol = '') AS empty_rows,
  sum(k_symbol != '') AS not_empty_rows
FROM
  trans
WHERE
  k_symbol IS NOT NULL;

/*
 The total of empty_rows is 415.123 and
 the total of not_empty_rows is 452.896
 
 which makes a total of 868.019 rows and
 meaning that we have no null values.
 
 
 */