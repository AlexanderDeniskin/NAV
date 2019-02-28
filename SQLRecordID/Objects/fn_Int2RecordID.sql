CREATE FUNCTION [dbo].[fn_Int2RecordID]
(
	@Value Integer,
	@AddType TinyInt = 0
)
RETURNS Varbinary(488)
AS
BEGIN
	Declare @IntVarBin Varbinary(4)
	Declare @RecID Varbinary(448)
	Declare @I Int

	Set @IntVarBin = CAST(@Value as varbinary(4))
	Set @I = 4
	WHILE @I > 0 BEGIN
		IF @RecID IS NULL
			Set @RecID = SUBSTRING(@IntVarBin,@I,1)
		ELSE
			Set @RecID = @RecID + SUBSTRING(@IntVarBin,@I,1)
		Set @I = @I - 1
	END

	IF @AddType = 1
		Set @RecID = 0x008B + @RecID -- Option field

	IF @AddType = 2
		Set @RecID = 0x0087 + @RecID -- Int field
		
	-- Return the result of the function
	RETURN @RecID

END
