use util
go
set nocount, xact_abort on
go

/*******************************************
* Type:			Inline Table-Valued Function
* Name:			core.SplayTerm
* Creator:		
* Created:		10/9/2020 10:04 PM
* Description:	Converts a string into a character array table
* Usage: 
		declare @term nvarchar(128) = current_user

		select top 1000 
			Input = @term,
			*
		from core.SplayTerm(@term)
				
* Modifications
* User			Date		Notes
* -------------------------------------------

*******************************************/
create or alter function core.SplayTerm
(
    @Term nvarchar(4000)
)
returns table
as
return
select
    Num,
    AsciiChar = char(num),
    UnicodeChar = nchar(num)
from core.Numbers
where num <= len(@Term)

go

