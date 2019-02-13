## This script allows to change ID of table in Nav 2017

```SQL
Declare @OldID int, @NewID int
Declare @NewLine varchar(1)

-- Renumber table from 50001 to 50002
Set @OldID = 50001
Set @NewID = 50002
Set @NewLine = CHAR(10)


IF ((Select COUNT(ID) from [Object] Where [Type] = 1 and [ID] = @OldID) = 0) BEGIN
	RAISERROR ('Table ID %d doesn''t exist.%sCannot renumber object.',16,1, @OldID, @NewLine)
	Return
END;

IF ((Select COUNT(ID) from [Object] Where [Type] = 1 and [ID] = @NewID) > 0) BEGIN
	RAISERROR ('Table ID %d already exists.%sCannot renumber object.',16,1, @NewID, @NewLine)
	Return
END;

Update [Object]
Set [ID] = @NewID
Where [Type] IN (0, 1) and [ID] = @OldID

Update [Object Metadata]
Set [Object ID] = @NewID
Where [Object Type] = 1	and [Object ID] = @OldID

Update [Object Metadata Snapshot]
Set [Object ID] = @NewID
Where [Object Type] = 1	and [Object ID] = @OldID

Delete from [Object Tracking]
where [Object Type] = 1 and [Object ID] = @NewID

Update [Object Tracking]
Set [Object ID] = @NewID
where [Object Type] = 1	and [Object ID] = @OldID

```
