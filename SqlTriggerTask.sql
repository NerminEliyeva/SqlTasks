USE Northwind

CREATE TRIGGER DML_Operations
ON dbo.Shippers
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    -- update
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        PRINT 'Güncelleme İşlemi Yapıldı'
    END
    
    -- insert
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    BEGIN
        PRINT 'Kayıt Ekleme İşlemi Yapıldı'
    END
    
    -- delete
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
    BEGIN
        PRINT 'Silme İşlemi Yapıldı'
    END
END

--For testing 
SELECT * from Shippers

INSERT INTO dbo.Shippers Values('test','234567890')

DELETE FROM Shippers WHERE ShipperID = 9
UPDATE Shippers

SET CompanyName = 'update test'
WHERE ShipperID = 10;