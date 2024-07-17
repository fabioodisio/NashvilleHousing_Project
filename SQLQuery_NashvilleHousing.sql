

--Cleaning Data in SQL Queries 

select * 
from [Portfolio Project].dbo.NashvilleHousing

-------------------------------------------------------------------------------------

--Standardize sale date format

select SaleDateConverted, CONVERT(Date, SaleDate)
from [Portfolio Project].dbo.NashvilleHousing


Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)


Alter Table NashvilleHousing
add SaleDateConverted Date;


update NashvilleHousing
set SaleDateConverted = CONVERT (Date,SaleDate)

---------------------------------------------------------------------------------------------

--
--populate Property Address data

select *
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
join [Portfolio Project].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
join [Portfolio Project].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]


-----------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

from [Portfolio Project].dbo.NashvilleHousing


Alter Table NashvilleHousing
add PropertySplitAddress Nvarchar(255);


update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
add PropertySplitCity Nvarchar(255);


update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



select *
from [Portfolio Project].dbo.NashvilleHousing




select OwnerAddress
from [Portfolio Project].dbo.NashvilleHousing



select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
from [Portfolio Project].dbo.NashvilleHousing




Alter Table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);


update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table NashvilleHousing
add OwnerSplitCity Nvarchar(255);


update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table NashvilleHousing
add OwnerSplitState Nvarchar(255);


update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


select * 
from [Portfolio Project].dbo.NashvilleHousing


----------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as Vacant' Field

select distinct (SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project].dbo.NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [Portfolio Project].dbo.NashvilleHousing

update NashvilleHousing 
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end


------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

with RowNumCTE as (
select *,
     ROW_NUMBER() over(
	 partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  order by
				       UniqueID
					   ) row_num


from [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress



------------------------------------------------------------------------------------

--Delete Unused Columns

select *
from [Portfolio Project].dbo.NashvilleHousing


alter table [Portfolio Project].dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [Portfolio Project].dbo.NashvilleHousing
drop column SaleDate

