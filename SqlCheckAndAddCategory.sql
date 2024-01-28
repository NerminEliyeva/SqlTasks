USE Northwind

CREATE PROCEDURE sp_AddCategory
@name nvarchar(15)
AS
BEGIN
     IF LTRIM(Lower(@name)) IN (SELECT Lower(CategoryName) FROM Categories)
     BEGIN 
	     PRINT Concat('Bu kategori :', @name,' kategoriler tablosunda mevcuttur')
     END

	 ELSE
	     INSERT INTO Categories (CategoryName) Values(@name)
END

Select * From Categories
Delete from Categories where CategoryID > 100

EXECUTE sp_AddCategory 'new cat'