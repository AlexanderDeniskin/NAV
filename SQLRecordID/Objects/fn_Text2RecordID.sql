CREATE FUNCTION [dbo].[fn_Text2RecordID]
(
	@Text varchar(250),
	@AddType TinyInt = 0
)
RETURNS Varbinary(488)
AS
BEGIN
	Declare @RecID Varbinary(448)
	Declare @I Int

	Set @I = 1 
	WHILE @I <= Len(@Text) BEGIN
		IF @RecID Is NULL
			Set @RecID = Cast(SUBSTRING(@Text,@I,1) as varbinary(1)) + 0x00
		ELSE 
			Set @RecID = @RecID + Cast(SUBSTRING(@Text,@I,1) as varbinary(1)) + 0x00
		Set @I = @I + 1
	END
	Set @RecID = @RecID + 0x0000

	IF @AddType = 1
		Set @RecID = 0x027BFF + @RecID -- Code field

	-- Return the result of the function
	RETURN @RecID

END
