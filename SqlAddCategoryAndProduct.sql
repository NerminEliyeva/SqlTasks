USE Northwind
--CategoryName, Description, ProductName, UnitPrice ve UnitsInStock
CREATE PROCEDURE sp_AddCategoryAndProduct
@categoryName nvarchar(15),
@description ntext,
@productName nvarchar(40),
@unitPrice money,
@unitsInStock smallint
AS
BEGIN
     IF LTRIM(Lower(@categoryName)) NOT IN (SELECT Lower(CategoryName) FROM Categories)
     BEGIN 
	     PRINT Concat('Kategori :', @categoryName,' ekleniyor')
		 INSERT INTO Categories (CategoryName, Description) 
		 VALUES(@categoryName, @description)

		 PRINT Concat('Urun :', @productName,' ekleniyor')
		 INSERT INTO Products (ProductName, UnitPrice, UnitsInStock, CategoryId) 
		 VALUES(@productName, @unitPrice, @unitsInStock,
		(SELECT CategoryId FROM Categories WHERE Lower(CategoryName) = LTRIM(Lower(@categoryName)) ))
     END

	 ELSE
	 BEGIN
		 PRINT Concat('Bu kategori :', @categoryName,' kategoriler tablosunda mevcuttur')
	     INSERT INTO Products (ProductName, UnitPrice, UnitsInStock, CategoryId) 
		 VALUES(@productName, @unitPrice, @unitsInStock,(SELECT CategoryId FROM Categories 
														     WHERE Lower(CategoryName) = LTRIM(Lower(@categoryName))) 
														    )
     END
END

SELECT * FROM Categories -- 8 rows
SELECT * FROM Products -- 77 rows

--Delete from Products where ProductID > 77
--Delete from Categories where CategoryID > 1000

--Execute sp_AddCategoryAndProduct 'Produce','test procedure','test procedure','5','5' 
--Execute sp_AddCategoryAndProduct 'test procedure','test procedure','test procedure','5','5' 

													    