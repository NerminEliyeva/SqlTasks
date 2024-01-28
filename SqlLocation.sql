CREATE DATABASE LocationDb;

USE LocationDb;

CREATE TABLE Countries (
    CountryID INT PRIMARY KEY identity,
    CountryName VARCHAR(50) NOT NULL
);
CREATE TABLE Cities (
    CityID INT PRIMARY KEY identity,
    CityName VARCHAR(50) NOT NULL,
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);
CREATE TABLE Districts (
    DistrictID INT PRIMARY KEY identity,
    DistrictName VARCHAR(50) NOT NULL,
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
CREATE TABLE Towns (
    TownID INT PRIMARY KEY identity,
    TownName VARCHAR(50) NOT NULL,
    DistrictID INT,
    FOREIGN KEY (DistrictID) REFERENCES Districts(DistrictID)
);


CREATE PROCEDURE sp_AddLocation
@country nvarchar(50),
@city nvarchar(50),
@distinct nvarchar(50),
@town nvarchar(50)
AS
BEGIN
		IF LTRIM(Lower(@country)) in (Select Lower(CountryName) FROM Countries)
		BEGIN
		PRINT Concat('Bu ulke :', @country,' tabloda mevcuttur')
		END
		ELSE
		INSERT INTO Countries (CountryName) VALUES(@country)

		--Şehir Kontrolü ve Ekleme: Ülkenin ID'sini kullanarak, şehrin varlığını kontrol edin, yoksa ilgili ülke ID'si ile ekleyin.
		IF LTRIM(Lower(@city)) in (Select Lower(CityName) FROM Cities JOIN Countries ON Cities.CountryID = Countries.CountryID) 
		BEGIN
		PRINT Concat('Bu sehir :', @city,' tabloda mevcuttur')
		END
		ELSE
		INSERT INTO Cities (CityName, CountryID) VALUES(@city , 
		                                                   (SELECT CountryID FROM Countries 
														     WHERE Lower(CountryName) = LTRIM(Lower(@country))) 
														    )
 
		--İlçe Kontrolü ve Ekleme: Şehrin ID'sini kullanarak, ilçenin varlığını kontrol edin, yoksa ilgili şehir ID'si ile ekleyin.
		IF LTRIM(Lower(@distinct)) in (Select Lower(DistrictName) from Districts JOIN Cities ON Cities.CityId = Districts.CityID) 
		BEGIN
		PRINT Concat('Bu ilce :', @distinct,' tabloda mevcuttur')
		END
		ELSE
		Insert Into Districts (DistrictName, CityID) VALUES(@distinct,
		                                                   (SELECT CityID FROM Cities 
														     WHERE Lower(CityName) = LTRIM(Lower(@city))) 
														 	)

		--Mahalle Kontrolü ve Ekleme: İlçenin ID'sini kullanarak, mahallenin varlığını kontrol edin, yoksa ilgili ilçe ID'si ile ekleyin.
		IF LTRIM(Lower(@town)) in (Select Lower(TownName) FROM Towns JOIN Districts ON Districts.DistrictID = Towns.DistrictID) 
		BEGIN
		PRINT Concat('Bu mahalle :', @town,' tabloda mevcuttur')
		END
		ELSE
		INSERT INTO Towns (TownName, DistrictID) VALUES(@town,
		                                                    (SELECT DistrictID FROM Districts 
														      WHERE Lower(DistrictName) = LTRIM(Lower(@distinct))) 
															 )
END

--Execute sp_AddLocation 'Azerbaycan','Baki','Xetai','Mehemmed Hadi' 
--Execute sp_AddLocation 'Azerbaycan','Baki','Xetai','Xudu Memmedov' 
--Execute sp_AddLocation 'Azerbaycan','Baki','Nerimanov','Aga Neymetulla' 
--Execute sp_AddLocation 'Azerbaycan','Baki','Nerimanov','Aga NeYMetulla'
--Execute sp_AddLocation 'Azerbaycan','Gence','Nerimanov','Aga Neymetulla'

Select * from Countries
select * from Cities
select * from Districts
select * from Towns

--Delete From Towns
--Delete From Districts
--Delete From Cities
--Delete From Countries


