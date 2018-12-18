# SQL Query
Allows to run SQL query for data update inside current nav trasaction and rollback it in case of error

## Installation
1. Import [Table 50006 SQL Query.txt](Table%2050006%20SQL%20Query.txt) and [Page 50006 SQL Query List.txt](Page%2050006%20SQL%20Query%20List.txt) (Change objects ID before import if necessary).
2. Create trigger for [SQL Query] table from [SQLTrigger.sql](SQLTrigger.sql).

File [Page 50007 SQL Query Examples.txt](Page%2050007%20SQL%20Query%20Examples.txt) contains three examples:
1. How to insert data.
2. How to update data.
3. What if error will occur (rollback changes).
