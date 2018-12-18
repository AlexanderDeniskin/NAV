# SQL Query
Allows to run SQL query for data update inside current nav trasaction and rollback it in case of error

## Installation
1. Import [Table50006.txt](Table50006.txt) and [Page50006.txt](Page50006.txt) (Change objects ID before import if necessary).
2. Create trigger for [SQL Query] table from [SQLTrigger.sql](SQLTrigger.sql).

File [Page50007.txt](Page50007.txt) contains three examples:
1. How to insert data.
2. How to update data.
3. What if error will occur (rollback changes).
