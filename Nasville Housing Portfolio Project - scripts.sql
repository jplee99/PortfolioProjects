

Select *
from [Portfolio Project JL].dbo.[Nashville Housing]




Select SaleDateConverted, CONVERT(date,SaleDate)
from [Portfolio Project JL].dbo.[Nashville Housing]


Update [Nashville Housing]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing]
add SaleDateConverted Date;

Update [Nashville Housing]
Set SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate porperty address data
Select *
from [Portfolio Project JL].dbo.[Nashville Housing]
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project JL].dbo.[Nashville Housing] a
JOIN [Portfolio Project JL].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) -- if it is null it can populate with other value as specified
from [Portfolio Project JL].dbo.[Nashville Housing] a
JOIN [Portfolio Project JL].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out the addresses 
Select PropertyAddress
from [Portfolio Project JL].dbo.[Nashville Housing] 

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from [Portfolio Project JL].dbo.[Nashville Housing] 

-- add new colums to the table

ALTER TABLE [Nashville Housing]
add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE [Nashville Housing]
add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select *
From [Portfolio Project JL].dbo.[Nashville Housing]


Select OwnerAddress
From [Portfolio Project JL].dbo.[Nashville Housing]

Select 
PARSENAME(Replace(OwnerAddress, ',','.') , 3) 
,PARSENAME(Replace(OwnerAddress, ',','.') , 2)
,PARSENAME(Replace(OwnerAddress, ',','.') , 1)-- parsename looks for dots/not commas - easier than substring 
From [Portfolio Project JL].dbo.[Nashville Housing]


ALTER TABLE [Nashville Housing]
add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.') , 3) 


ALTER TABLE [Nashville Housing]
add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitCity= PARSENAME(Replace(OwnerAddress, ',','.') , 2)


ALTER TABLE [Nashville Housing]
add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.') , 1)

Select *
From [Portfolio Project JL].dbo.[Nashville Housing]

-- Sold as Vacant field 

Select Distinct (SoldAsVacant), Count(SoldAsVacant)		
From [Portfolio Project JL].dbo.[Nashville Housing]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project JL].dbo.[Nashville Housing]

Update [Portfolio Project JL].dbo.[Nashville Housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNUMCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
					uniqueID
					) row_num
From [Portfolio Project JL].dbo.[Nashville Housing]
--Order by ParcelID
)

Select *
From RowNUMCTE
Where row_num > 1
Order by PropertyAddress




DELETE --- deleting duplicates 
From RowNUMCTE
Where row_num > 1
--Order by PropertyAddress


-- Delete some Columns
Select *
from [Portfolio Project JL].dbo.[Nashville Housing] 


ALTER TABLE [Portfolio Project JL].dbo.[Nashville Housing] 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project JL].dbo.[Nashville Housing] 
DROP COLUMN SaleDate