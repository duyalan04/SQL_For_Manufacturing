-- SQL CODE
hello 
--VIEW
--2 VIEW ĐƠN GIẢN

--2 VIEW PHỨC TẠP

--1 VIEW UPDATE

--PROCEDURE
--1 KHÔNG THAM SỐ

--1 CÓ THAM SỐ DEFAULT

-- THAM SỐ INPUT

--1 THAM SỐ OUTPUT

--FUNCTION
--2 TRẢ VÔ HƯỚNG

--2 TRẢ VỀ BẢNG

--1 TRẢ VỀ KIỂU TỰ ĐỊNH NGHĨA

--TRIGGER
--1 TRIG UPDATE

--1 TRIG INSERT

--1 TRIG DELETE

--2 TRANSACTION



--PROCEDURE

----hien thi thong tin hoa don khi bomlevel = 3
CREATE PROC HienthithongtinHoadon
AS
BEGIN
SELECT *from [Production.BillOfMaterials]
WHERE PerAssemblyQty = 4 AND BOMLevel = 2
END

EXEC HienthithongtinHoadon


----cập nhật 1 sản phẩm mới
ALTER PROCEDURE UpdateProduct
    @ProductID INT,
    @NewProductName NVARCHAR(50),
    @Color NVARCHAR(15),
    @NewListPrice MONEY
AS
BEGIN
    -- Cập nhật thông tin sản phẩm trong bảng Products
    UPDATE [Production.Product]
    SET [Name] = @NewProductName,
        Color = @Color,
        ListPrice = @NewListPrice
    WHERE ProductID = @ProductID

    -- In ra thông báo thành công
    PRINT 'Thông tin sản phẩm có ID ' + CAST(@ProductID AS NVARCHAR(10)) + ' đã được cập nhật.'
END
EXEC UpdateProduct @ProductID = 10001, @NewProductName = 'Sản phẩm B', @Color = 'WhiteGray', @NewListPrice = 60.00


----Tạo proc để tính tổng chi phí sản phẩm dựa trên các thông tin về nguyên liệu và công việc
ALTER PROC CalculateProductionCost
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    -- Tính tổng chi phí nguyên vật liệu
    DECLARE @MaterialCost DECIMAL(10, 2)
    SELECT @MaterialCost = SUM(ActualCost * @Quantity)
    FROM [Production.TransactionHistory]
    WHERE ProductID = @ProductID

    -- Tính tổng chi phí công việc
    DECLARE @LaborCost DECIMAL(10, 2)
    SELECT @LaborCost = ListPrice * StandardCost
    FROM [Production.Product]
    WHERE ProductID = @ProductID

    -- Tổng chi phí sản xuất
    DECLARE @TotalCost DECIMAL(10, 2)
    SET @TotalCost = @MaterialCost + @LaborCost

    -- In ra kết quả
	PRINT 'Tong chi phi san xuat cho san pham ' + CAST(@ProductID AS NVARCHAR(10)) + ' là ' + CAST(@TotalCost AS NVARCHAR(20))END
EXEC CalculateProductionCost @ProductID = 956, @Quantity = 2


----output về thông tin chi tiết sản phẩm
ALTER PROC GetProductDetails
    @ProductID INT,
    @ProductName NVARCHAR(50) OUTPUT,
    @Number NVARCHAR(50) OUTPUT,
    @ListPrice Money OUTPUT
AS
BEGIN
    -- Lấy thông tin sản phẩm dựa trên ID sản phẩm
    SELECT @ProductName = [Name], @Number = ProductNumber, @ListPrice = ListPrice
    FROM [Production.Product]
    WHERE ProductID = @ProductID
END
DECLARE @ProductID INT = 518
DECLARE @ProductName NVARCHAR(50)
DECLARE @Number NVARCHAR(1000)
DECLARE @ListPrice Money

EXEC GetProductDetails @ProductID, @ProductName OUTPUT, @Number OUTPUT, @ListPrice OUTPUT

PRINT 'Thong tin san pham co ID: '+CAST(@ProductID AS NVARCHAR(10)) 
PRINT 'Ten san pham: ' + @ProductName
PRINT 'Ma san pham: ' + @Number
PRINT 'Giá: ' + CAST(@ListPrice AS NVARCHAR(20))


----xay dung thu tuc nhap vao 
CREATE PROC p_ThongtinProduct (@ProductID SMALLINT)
AS
BEGIN 
	IF @ProductID NOT IN (SELECT ProductID FROM [Production.Product])
	PRINT(N'Mã không tồn tại')
ELSE
	SELECT ProductID,[Name],ProductNumber
	FROM [Production.Product]
	WHERE ProductID = @ProductID
END
EXEC p_ThongtinProduct 531

----thong tin historyarchive từ productid
CREATE PROC p_ThongtinTHA (@ProductID INT)
AS
BEGIN
	IF @ProductID NOT IN (SELECT ProductID FROM	[Production.TransactionHistoryArchive])
	PRINT (N'Mã không tồn tại')
ELSE
	SELECT *FROM [Production.TransactionHistoryArchive]
	WHERE ProductID = @ProductID
END
EXEC p_ThongtinTHA 716
