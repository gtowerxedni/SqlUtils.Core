use master
go
/*****************************
Create [util] database
*****************************/
if db_id('util') is null
begin
	create database util
	raiserror('Created database [util]', 0, 1) with nowait
end
go