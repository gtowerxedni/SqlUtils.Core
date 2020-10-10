use util
go
set nocount, xact_abort on
go
/*******************************************
* Type:			Table
* Name:			core.Numbers
* Creator:		
* Created:		10/9/2020 9:48 PM
* Description:	Tally table. Includes population script
* Usage: 
		select top 1000 *
		from core.Numbers
				
* Modifications
* User			Date		Notes
* -------------------------------------------

*******************************************/
drop table if exists core.Numbers
create table core.Numbers
(
	Num int not null 
)
insert into core.Numbers(Num)
select top 2000000 row_number() over ( order by (select null))
from sys.all_objects a, sys.all_objects b, sys.all_objects c

alter table core.Numbers
add constraint PKC__core_Numbers__NumbersId primary key clustered (Num)

