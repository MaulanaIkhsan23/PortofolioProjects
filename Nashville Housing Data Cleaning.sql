/*

Cleaning Data in SQL Queries

*/

Select *
From PortofolioProject..NashvilleHousing

---------------------------------------------------------------------------------------------------

--Standarize Date Format

Select SaleDateConverted, convert(Date, SaleDate)
From PortofolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = convert(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = convert(Date, SaleDate)


---------------------------------------------------------------------------------------------------

--Populate Property Address date

Select *
From PortofolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
From PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
From PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



---------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortofolioProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortofolioProject..NashvilleHousing


ALTER TABLE PortofolioProject..NashvilleHousing
add PropertySplitAddress nvarchar(255);

update PortofolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortofolioProject..NashvilleHousing
add PropertySplitCity nvarchar(255);

update PortofolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



select *
From PortofolioProject..NashvilleHousing





select OwnerAddress
From PortofolioProject..NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PortofolioProject..NashvilleHousing



ALTER TABLE PortofolioProject..NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update PortofolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE PortofolioProject..NashvilleHousing
add OwnerSplitCity nvarchar(255);

update PortofolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE PortofolioProject..NashvilleHousing
add OwnerSplitState nvarchar(255);

update PortofolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)




select *
From PortofolioProject..NashvilleHousing





---------------------------------------------------------------------------------------------------

-- Change Y and N to Yes dan No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortofolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
End
From PortofolioProject..NashvilleHousing



update PortofolioProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END





---------------------------------------------------------------------------------------------------

-- Remove Duplicate

WITH RowNumCTE AS(
select *,
	ROW_NUMBER()OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortofolioProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress



Select *
From PortofolioProject..NashvilleHousing




---------------------------------------------------------------------------------------------------

-- Remove Unused Colums


Select *
From PortofolioProject..NashvilleHousing


ALTER TABLE PortofolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortofolioProject..NashvilleHousing
DROP COLUMN SaleDate