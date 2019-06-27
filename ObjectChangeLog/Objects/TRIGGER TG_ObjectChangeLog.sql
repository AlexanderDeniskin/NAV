CREATE TRIGGER [dbo].[TG_ObjectChangeLog] ON [dbo].[Object] 
AFTER INSERT, UPDATE, DELETE 
AS 
SET NOCOUNT ON 
 
DECLARE @ins_count int 
DECLARE @del_count int 
DECLARE @rnm_ID int 
DECLARE @LastLogEntryNo int

SELECT @ins_count = COUNT(*) FROM inserted 
SELECT @del_count = COUNT(*) FROM deleted 
SELECT @rnm_ID = ID from deleted 


SET @LastLogEntryNo = ISNULL((SELECT TOP 1 [Entry No_] from [Object Change Log] Order by [Entry No_] Desc),0)

IF (@ins_count <> 0) BEGIN 
	-- Object inserted or updated

	-- Update last entry if BLOB is not changed and don't create new log entry
	UPDATE [Object Change Log]
		SET [Modified] = inserted.Modified
			,[Compiled] = inserted.Compiled
			,[BLOB Size] = inserted.[BLOB Size]
			,[DBM Table No_] = inserted.[DBM Table No_]
			,[Locked] = inserted.Locked
			,[Locked By] = inserted.[Locked By]
			,[Version List] = inserted.[Version List]
			,[Changed DateTime] = GETUTCDATE()
	FROM inserted
	LEFT JOIN [dbo].[Object] obj ON 
				obj.[Type] = inserted.[Type] 
				AND obj.[Company Name] = inserted.[Company Name] 
				AND obj.[ID] = inserted.[ID]
	WHERE
	 [Object Change Log].[Entry No_] = @LastLogEntryNo and
	 [Object Change Log].[Object Type] = inserted.[Type] and
	 [Object Change Log].[Object ID] = inserted.ID and
	 [Object Change Log].[Type of Change] IN (1,2) and
	 [Object Change Log].[Object Date] = inserted.[Date] and
	 [Object Change Log].[Object Time] = inserted.[Time] and	 	 
	 [Object Change Log].[Changed by User] = SUSER_NAME() and
	 [Object Change Log].[Changed DateTime] > DATEADD(s,-20,GETUTCDATE()) and
	 convert(varbinary,[Object Change Log].[BLOB Reference]) = convert(varbinary,obj.[BLOB Reference])

	 IF @@ROWCOUNT = 0
		INSERT INTO [dbo].[Object Change Log]
				([Object Type]
				,[Object ID]
				,[Object Name]
				,[Modified]
				,[Compiled]
				,[BLOB Reference]
				,[BLOB Size]
				,[DBM Table No_]
				,[Object Date]
				,[Object Time]
				,[Version List]
				,[Locked]
				,[Locked By]
				,[Changed by User]
				,[Changed DateTime]
				,[Type of Change]
				,[Renumbered From ID])
			SELECT 
				ins.[Type]
				,ins.[ID]
				,ins.[Name] 
				,ins.[Modified] 
				,ins.[Compiled] 
				,obj.[BLOB Reference] 
				,ins.[BLOB Size] 
				,ins.[DBM Table No_]
				,ins.[Date] 
				,ins.[Time] 
				,ins.[Version List] 
				,ins.[Locked]
				,ins.[Locked By]
				,SUSER_NAME() 
				,GETUTCDATE() 
				,CASE 
					WHEN @del_count = 0 THEN 1  -- Insert
					WHEN @rnm_ID = ins.ID THEN 2 -- update
					ELSE 4  -- rename
				END
				,CASE 
					WHEN @rnm_ID = ins.ID THEN 0 
					ELSE ISNULL(@rnm_ID,0)
				END
			FROM inserted ins 
			LEFT JOIN [dbo].[Object] obj ON 
				obj.[Type] = ins.[Type] 
				AND obj.[Company Name] = ins.[Company Name] 
				AND obj.[ID] = ins.[ID] 
			WHERE ins.[Type] > 0 
END ELSE
IF (@del_count <> 0) 
  -- Object Deleted 
  INSERT INTO [dbo].[Object Change Log]
			([Object Type]
			,[Object ID]
			,[Object Name]
			,[Modified]
			,[Compiled]
			,[BLOB Reference]
			,[BLOB Size]
			,[DBM Table No_]
			,[Object Date]
			,[Object Time]
			,[Version List]
			,[Locked]
			,[Locked By]
			,[Changed by User]
			,[Changed DateTime]
			,[Type of Change]
			,[Renumbered From ID])
		SELECT 
			del.[Type]
			,del.[ID]
			,del.[Name] 
			,del.[Modified] 
			,del.[Compiled] 
			,obj.[BLOB Reference] 
			,del.[BLOB Size] 
			,del.[DBM Table No_]
			,del.[Date] 
			,del.[Time] 
			,del.[Version List] 
			,del.[Locked]
			,del.[Locked By]
			,SUSER_NAME() 
			,GETUTCDATE()  
			,3 
			,0
    FROM deleted del 
        LEFT JOIN [dbo].[Object] obj ON 
			obj.[Type] = del.[Type] 
			AND obj.[Company Name] = del.[Company Name] 
			AND obj.[ID] = del.[ID] 
    WHERE del.[Type] > 0 
