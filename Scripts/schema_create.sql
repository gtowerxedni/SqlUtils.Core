use util
go
set nocount on
go
/*****************************
Create [core] schema
*****************************/
if schema_id('core') is null
begin
	exec (N'create schema [core]')
	print N'created schema [core]'
end
go
