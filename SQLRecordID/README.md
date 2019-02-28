# Working with Record ID fields via SQL
##### Convert primary key values to varbinary Record ID:
```SQL
SELECT TOP 1 
	[Document Type]
	,[No_]
	,[Doc_ No_ Occurrence]
	,[Version No_]
	,[dbo].[fn_Int2RecordID](5109,0)  -- 0 for Table No. (don't add field type chars)
		+[dbo].[fn_Int2RecordID]([Document Type],1)  -- 1 for option fields
		+[dbo].[fn_Text2RecordID]([No_],1) 
		+[dbo].[fn_Int2RecordID]([Doc_ No_ Occurrence],2)  -- 2 for integer fields
		+[dbo].[fn_Int2RecordID]([Version No_],2) 
		+0x0000 as [RecordID]
FROM [CompanyName$Purchase Header Archive] PHA
```
```SQL
SELECT TOP 1 
	[No_]
	,[dbo].[fn_Int2RecordID](27,0) 
		+[dbo].[fn_Text2RecordID]([No_],1) 
		+0x0000 as [RecordID]
FROM [CompanyName$Item]
```

##### Get readable Record ID value:
```SQL
Select top 50
	[Link ID]
	,[Record ID]
	,URL1+URL2+URL3+URL4 as [URL]
	,RecordIdInfo.*
from [Record Link]
CROSS APPLY dbo.[fn_FormatRecordID]([Record ID]) RecordIdInfo
```
##### Filter by Table No. of Record ID:
```SQL
SELECT * FROM [Record Link]
WHERE 
  CAST(
    SUBSTRING([Record ID],4,1)+
    SUBSTRING([Record ID],3,1)+
    SUBSTRING([Record ID],2,1)+
    SUBSTRING([Record ID],1,1) 
  as Int) = 27 -- Item table
```

These functions support only Option, Integer, Text and Code data types.
