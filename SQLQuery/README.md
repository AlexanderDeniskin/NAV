# SQL Query
Allows to run SQL query for data update inside current nav trasaction and rollback it in case of error

## Installation
1. Import [Table 50006 SQL Query.txt](Objects/Table%2050006%20SQL%20Query.txt) and [Page 50006 SQL Query List.txt](Objects/Page%2050006%20SQL%20Query%20List.txt) (Change objects ID before import if necessary).
2. Create trigger for [SQL Query] table from [SQLTrigger.sql](Objects/SQLTrigger.sql).

File [Page 50007 SQL Query Examples.txt](Objects/Page%2050007%20SQL%20Query%20Examples.txt) contains three examples:
1. How to insert data.
2. How to update data.
3. What if error will occur (rollback changes).

## Additional info
File [Codeunit 104050 Upgrade - SQL Mgt.txt](Objects/Codeunit%20104050%20Upgrade%20-%20SQL%20Mgt.txt) is from Nav 2013 upgrade toolkit. It can be used to run SQL queries from Nav.
