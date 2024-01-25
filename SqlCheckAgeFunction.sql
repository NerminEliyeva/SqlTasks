use Northwind

CREATE FUNCTION CheckAge(@birthDate date,@age int)
RETURNS nvarchar(max) 
AS
BEGIN
DECLARE @result nvarchar(max);
SET @result = 
       CASE 
	       WHEN DATEDIFF(YEAR,@birthDate,GETDATE()) = @age AND
		        DATEDIFF(MONTH,@birthDate,GETDATE()) != 0
	       THEN 'Yıl olarak doldurmuştur, ay ve gün olarak doldurmamıştır'

		   WHEN DATEDIFF(YEAR,@birthDate,GETDATE()) = @age AND
		         DATEDIFF(MONTH,@birthDate,GETDATE()) = 0 AND
				DAY(GETDATE()) < DAY(@birthDate)
	       THEN 'Yıl ve ay olarak doldurmuştur, gün olarak doldurmamıştır'

		   WHEN DATEDIFF(YEAR,@birthDate,GETDATE()) < @age 
	       THEN 'Kişi henüz yıl, ay ve gün olarak yaşını doldurmamıştır'
           ELSE 'Kişi yaşını doldurmuştur' 
	   END
    RETURN @result;
END 

Select EmployeeID,
       BirthDate,
	   DATEDIFF(year,BirthDate,getdate()) Age,
	   dbo.CheckAge(BirthDate,61) CheckAge  
from Employees