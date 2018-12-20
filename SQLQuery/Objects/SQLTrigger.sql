CREATE TRIGGER [dbo].[TG_ExecuteQuery] ON [dbo].[SQL Query]
AFTER INSERT
-- INSTEAD OF INSERT
AS 
SET NOCOUNT ON;
DECLARE @QueryText NVarchar(Max)
DECLARE @StartDateTime DateTime

SELECT 
	@QueryText = CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX),T.[Query Text])) 
FROM inserted Ins 
JOIN [SQL Query] T on 
	Ins.[Entry No_] = T.[Entry No_]

IF ISNULL(@QueryText,'') = ''
   Return;
BEGIN TRY
	Set @StartDateTime = GETUTCDATE();

	EXEC sp_executesql @QueryText

	UPDATE T
		Set [Duration] = DATEDIFF(MS,@StartDateTime,GETUTCDATE())
	FROM [SQL Query] T
	JOIN inserted Ins on
		Ins.[Entry No_] = T.[Entry No_]
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);  
	DECLARE @ErrorSeverity INT;  
	DECLARE @ErrorState INT;  

	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE(); 		
	
	IF @@TRANCOUNT > 0  
		ROLLBACK TRANSACTION;
				
	RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);   		
END CATCH
