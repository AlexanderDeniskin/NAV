CREATE FUNCTION [dbo].[fn_FormatRecordID]
(	
	@RecordID Varbinary(448)
)
RETURNS @RecordIdInfo TABLE (
        TableNo int,
        PrimaryKeyValue VARCHAR(500)
    )
AS
BEGIN


	Declare @I Int = 0	
	Declare @TableNo Int = 0
	Declare @DataType Int = 0
	Declare @Text NVarchar(Max)
	Declare @Char NChar(1)
	Declare @CharZero Int = 0
	Declare @Int Int
	Declare @DataTypeCheck TinyInt = 1


	Set @TableNo = Cast(SUBSTRING(@RecordID,3,1) + SUBSTRING(@RecordID,2,1) + SUBSTRING(@RecordID,1,1) as int)

	/*
	0 - Option
	2 - Code
	*/

	Set @I = 5

	WHILE @I < DATALENGTH(@RecordID)
	BEGIN  

		IF @DataTypeCheck = 1 BEGIN		
			IF @I+2 < DATALENGTH(@RecordID) BEGIN
				Set @DataType = Cast(SUBSTRING(@RecordID,@I,1) as int)
				Set @DataTypeCheck = 0
				IF ISNULL(@Text,'') <> ''
					Set @Text = CONCAT(@Text,';')

				Set @I = @I + 1
		
				IF @DataType = 2 
					IF SUBSTRING(@RecordID,@I+2,1) <> 0x00
						Set @I = @I + 1
		
				Set @CharZero = 0;
			END
		END ELSE BEGIN				
			IF @DataType = 2 BEGIN  -- Code

				Set @Char = Char(SUBSTRING(@RecordID,@I,1))

				IF (ASCII(@Char) > 0) 
					Set @Text = CONCAT(ISNULL(@Text,''),@Char)
			

				If ASCII(@Char) = 0 BEGIN
					Set @CharZero = @CharZero + 1
				END ELSE
					Set @CharZero = 0
				IF @CharZero = 3 
					Set @DataTypeCheck = 1
				END

			IF @DataType = 0 BEGIN -- Integer
				Set @I = @I + 3
				Set @Int = Cast(SUBSTRING(@RecordID,@I,1) + SUBSTRING(@RecordID,@I-1,1) + SUBSTRING(@RecordID,@I-2,1) + SUBSTRING(@RecordID,@I-3,1) as int)
				IF NOT @Int Is Null
					Set @Text = CONCAT(ISNULL(@Text,''),@Int)
			
				Set @DataTypeCheck = 1
			END

		
		END
		Set @I = @I + 1
	END  

	INSERT INTO @RecordIdInfo
	Select @TableNo, @Text

	RETURN;

END;
