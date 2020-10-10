use util
go
set nocount, xact_abort on
go
/*******************************************
* Type:			View
* Name:			core.vCharacters
* Creator:		
* Created:		10/9/2020 9:51 PM
* Description:	View over core.Numbers yielding common character recognition features
* Usage: 
		
		select top 1000 *
		from core.vCharacters
				
* Modifications
* User			Date		Notes
* -------------------------------------------

*******************************************/
create or alter view core.vCharacters
as
    with a as
    (
        select
            Char = nchar(num),
            UnicodePt = Num,
            AsciiPt = ascii(char(num)),
            Bin = cast(nchar(num) as binary(2))
        from core.numbers
    ), b as
    (
        select
			CodePtMatch = convert(bit, 
				case
					when UnicodePt = AsciiPt then 1
					when UnicodePt != AsciiPt then 0
					else null
				end),
            UnicodePt,
            a.Char,
            UpChar = upper(a.Char),
            LowChar = lower(a.Char),
            a.Bin,
            a.AsciiPt,
            IsUpperEng = convert(bit, iif(UnicodePt between 65 and 90, 1, 0)),
            IsLowerEng = convert(bit, iif(UnicodePt between 97 and 122, 1, 0)),
            IsDigit = convert(bit, iif(UnicodePt between 48 and 57, 1, 0))
        from a
    ), c as
    (
        select
			CodePtMatch,
			UnicodePt,
            b.Char,
            b.UpChar,
            b.LowChar,
            b.Bin,
            BinUp = convert(binary(2), b.UpChar),
            BinLow = convert(binary(2), b.LowChar),
            b.AsciiPt,
            b.IsUpperEng,
            b.IsLowerEng,
            b.IsDigit
        from b
    ), d as
    (
        select
			CodePtMatch,
			UnicodePt,
            c.Char,
            c.UpChar,
            c.LowChar,
            c.Bin,
            c.BinUp,
            c.BinLow,
            c.AsciiPt,
            c.IsUpperEng,
            c.IsLowerEng,
            c.IsDigit,
            IsCaseable = convert(bit, iif(c.BinUp = c.BinLow, 0, 1))
        from c
    ), e as
    (
        select
			CodePtMatch,
			UnicodePt,
            d.Char,
            d.UpChar,
            d.LowChar,
            d.Bin,
            d.BinUp,
            d.BinLow,
            d.AsciiPt,
            d.IsUpperEng,
            d.IsLowerEng,
            IsAlphaEng = d.IsUpperEng | d.IsLowerEng,
            d.IsDigit,
            d.IsCaseable,
            IsUpper = convert(bit, iif(d.IsCaseable = 1 and d.Bin = d.BinUp, 1, 0)),
            IsLower = convert(bit, iif(d.IsCaseable = 1 and d.Bin = d.BinLow, 1, 0))
        from d
    ), f as
    (
        select
			CodePtMatch,
			UnicodePt,
            e.Char,
            e.UpChar,
            e.LowChar,
            e.Bin,
            e.BinUp,
            e.BinLow,
            e.AsciiPt,
            e.IsUpperEng,
            e.IsLowerEng,
            e.IsAlphaEng,
            IsAlphaNumEng = e.IsAlphaEng | e.IsDigit,
            e.IsDigit,
            e.IsCaseable,
            e.IsUpper,
            e.IsLower,
            IsAlpha = e.IsUpper | e.IsLower
        from e
    )
    select
        f.Char,
        f.UpChar,
        f.LowChar,
        f.Bin,
        f.BinUp,
        f.BinLow,
		UnicodePt,
		f.AsciiPt,
		CodePtMatch,
        f.IsUpperEng,
        f.IsLowerEng,
        f.IsAlphaEng,
        f.IsAlphaNumEng,
        f.IsDigit,
        f.IsCaseable,
        f.IsUpper,
        f.IsLower,
        f.IsAlpha,
		IsAlphaNum = IsAlpha | IsDigit
    from f
go
