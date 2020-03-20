DECLARE @Name nvarchar(1000);
DECLARE @Sql nvarchar(1000);
DECLARE @Result int;

DECLARE ObjectCursor CURSOR FAST_FORWARD FOR
SELECT  SCHEMA_NAME(o.schema_id) + '.[' + OBJECT_NAME(o.object_id) + ']'
FROM sys.objects o
WHERE type_desc IN (
'SQL_STORED_PROCEDURE',
'SQL_TRIGGER',
'SQL_SCALAR_FUNCTION',
'SQL_TABLE_VALUED_FUNCTION',
'SQL_INLINE_TABLE_VALUED_FUNCTION',
'VIEW')
and isnull(objectproperty(o.object_id,'IsSchemaBound'),0)=0 -- don't check schemabinding they don't like it
and SCHEMA_NAME(o.schema_id) != 'cdc';

DECLARE @msg NVARCHAR(max)
OPEN ObjectCursor;

FETCH NEXT FROM ObjectCursor INTO @Name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Sql = N'EXEC sp_refreshsqlmodule ''' + @Name + '''';
	
    BEGIN TRY
        EXEC @Result = sp_executesql @Sql;
        IF @Result <> 0 RAISERROR('Failed', 16, 1);
    END TRY
    BEGIN CATCH
		SET @msg = (ISNULL(@msg,'')) + '\n' + @sql
	    PRINT 'The module ''' + @Name + ''' does not compile.';
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH

    FETCH NEXT FROM ObjectCursor INTO @Name;
END

CLOSE ObjectCursor;
DEALLOCATE ObjectCursor;

IF len(@msg) > 0
THROW 60000, @msg, 1; 
