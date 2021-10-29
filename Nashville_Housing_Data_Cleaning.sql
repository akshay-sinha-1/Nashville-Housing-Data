/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM Portfolio_Project_3..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Standarize Date Format (Change SaleDate)

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM Portfolio_Project_3.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


SELECT *
FROM Portfolio_Project_3..NashvilleHousing

SELECT SaleDateConverted
FROM Portfolio_Project_3..NashvilleHousing


-- Populate Property Address Data

SELECT *
FROM Portfolio_Project_3.dbo.NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project_3.dbo.NashvilleHousing a
JOIN Portfolio_Project_3.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project_3.dbo.NashvilleHousing a
JOIN Portfolio_Project_3.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM Portfolio_Project_3.dbo.NashvilleHousing
-- WHERE PropertyAddress IS NULL
-- ORDER BY ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS City

FROM Portfolio_Project_3.dbo.NashvilleHousing


ALTER TABLE Portfolio_Project_3.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE Portfolio_Project_3.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Portfolio_Project_3.dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE Portfolio_Project_3.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM Portfolio_Project_3..NashvilleHousing



SELECT OwnerAddress
FROM Portfolio_Project_3.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Portfolio_Project_3.dbo.NashvilleHousing


ALTER TABLE Portfolio_Project_3.dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

ALTER TABLE Portfolio_Project_3.dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

ALTER TABLE Portfolio_Project_3.dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE Portfolio_Project_3.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE Portfolio_Project_3.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE Portfolio_Project_3.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT *
FROM Portfolio_Project_3..NashvilleHousing



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio_Project_3..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 ASC


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Portfolio_Project_3..NashvilleHousing


UPDATE Portfolio_Project_3..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END






-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates 

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER()OVER(
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
									   
FROM Portfolio_Project_3..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress




-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DELETE Unused Columns

SELECT *
FROM Portfolio_Project_3..NashvilleHousing

ALTER TABLE Portfolio_Project_3..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate