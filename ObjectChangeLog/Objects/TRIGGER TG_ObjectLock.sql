-- Automatically set Locked when changing an object
CREATE TRIGGER [dbo].[TG_ObjectLock] ON [dbo].[Object] 
AFTER INSERT, UPDATE
AS 
SET NOCOUNT ON;

DECLARE @ins_count int

SELECT @ins_count = COUNT(*) FROM inserted where inserted.Locked = 1
IF (ISNULL(@ins_count,1) = 1) Return;

DECLARE @del_count int
DECLARE @InsTime DateTime

select @InsTime = [Date] + Cast(CONVERT(TIME, [Time]) as DateTime) from inserted

SELECT @del_count = COUNT(*) 
FROM deleted
LEFT JOIN inserted on
	deleted.ID = inserted.ID
WHERE 
	deleted.Locked = 1 and 
	ISNULL(inserted.Locked,0) = 0 and
	deleted.[BLOB Size] = ISNULL(inserted.[BLOB Size],deleted.[BLOB Size]) and
	ABS(DATEDIFF(s, GETDATE(), ISNULL(@InsTime,GETDATE()))) > 0

IF (ISNULL(@del_count,0) = 1) Return;

 
Update Object 
	Set 
		[Locked] = 1,
		[Locked By] = (Select CAST(RTRIM(SP.[loginame]) AS NVARCHAR(64)) COLLATE Latin1_General_100_CI_AS AS "User ID" 
						from [master].[dbo].[sysprocesses] SP	
						where SP.[spid] = @@SPID)
from Object Obj
join inserted on
	Obj.[Type] = inserted.[Type] and
	Obj.[Company Name] = inserted.[Company Name] and
	Obj.ID = inserted.ID and
	Obj.[Locked] = 0 and
	inserted.Locked = 0;

SET NOCOUNT OFF 
