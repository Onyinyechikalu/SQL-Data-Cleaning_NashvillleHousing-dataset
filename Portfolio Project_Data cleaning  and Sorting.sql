--Data cleaning and sorting


Select *
From [Portfolio Project].dbo.NashvilleHousing

--Standardize the data format( Changing the Date Format)

Select SaleDate, convert(Date,SaleDate) as NewDate
From [Portfolio Project].dbo.NashvilleHousing

Update [Portfolio Project].dbo.NashvilleHousing
Set SaleDate = convert(Date,SaleDate) 

--Select SaleDate
--from [Portfolio Project].dbo.NashvilleHousing.

 Alter table [Portfolio Project].dbo.NashvilleHousing
Add SaleDateconverted  Date;

Update [Portfolio Project].dbo.NashvilleHousing
Set SaleDateconverted = convert(Date,SaleDate) 

Select SaleDateconverted, convert(Date,SaleDate) as NewDate
From [Portfolio Project].dbo.NashvilleHousing

---Populating the Property address data 

Select *
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,isnull(a.propertyAddress, b.PropertyAddress) as NewPropertyAddress
from [Portfolio Project].dbo.NashvilleHousing  a
join [Portfolio Project].dbo.NashvilleHousing  b
 on a.ParcelID = b.ParcelID
 and a. [UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is not null


 Update a
 set PropertyAddress = isnull(a.propertyAddress, b.PropertyAddress) 
 from [Portfolio Project].dbo.NashvilleHousing  a
join [Portfolio Project].dbo.NashvilleHousing  b
 on a.ParcelID = b.ParcelID
 and a. [UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null

 --Setting address into individual columns (Address, city, States)

 Select 
 SUBSTRING (PropertyAddress,1,CHARINDEX(',',propertyAddress)-1) as address,
 SUBSTRING (PropertyAddress,CHARINDEX(',',propertyAddress)+1, len(propertyAddress)) as address
from [Portfolio Project].dbo.NashvilleHousing

--Creating the tables for the splited address

 Alter table [Portfolio Project].dbo.NashvilleHousing
Add PropertysplitAddress  nvarchar(255)

Update [Portfolio Project].dbo.NashvilleHousing
Set PropertysplitAddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',propertyAddress)-1)


 Alter table [Portfolio Project].dbo.NashvilleHousing
Add Propertysplitcity  nvarchar(255) 

Update [Portfolio Project].dbo.NashvilleHousing
Set PropertysplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',propertyAddress)+1, len(propertyAddress)) 

Select *
from [Portfolio Project].dbo.NashvilleHousing



--Splitting the ownersAddress

Select OwnerAddress
from [Portfolio Project].dbo.NashvilleHousing

--Spiting can also be done using PARSENAME as below;

Select
PARSENAME(Replace(OwnerAddress, ',' , '.') , 3) as OwnersAddress
,PARSENAME(Replace (OwnerAddress, ',' , '.') ,2) as Ownerscity
,PARSENAME(Replace (OwnerAddress, ',' , '.') ,1) as OwnersState
from [Portfolio Project].dbo.NashvilleHousing


Alter table [Portfolio Project].dbo.NashvilleHousing
Add OwnersplitAddress  nvarchar(255)

Update [Portfolio Project].dbo.NashvilleHousing
Set OwnersplitAddress = PARSENAME(Replace(OwnerAddress, ',' , '.') , 3) 

Alter table [Portfolio Project].dbo.NashvilleHousing
Add Ownersplitcity  nvarchar(255)

Update [Portfolio Project].dbo.NashvilleHousing
Set Ownersplitcity = PARSENAME(Replace (OwnerAddress, ',' , '.') ,2)


Alter table [Portfolio Project].dbo.NashvilleHousing
Add OwnersplitState  nvarchar(255)

Update [Portfolio Project].dbo.NashvilleHousing
Set OwnersplitState = PARSENAME(Replace (OwnerAddress, ',' , '.') ,1)

Select *
from [Portfolio Project].dbo.NashvilleHousing



--Changing Y and N as yes and No in "sold as vacant' field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant

Select SoldAsVacant
 ,case
   when SoldAsVacant = 'Y' then 'Yes'
   when soldAsVacant = 'N' then 'No'
   Else SoldAsVacant
   End
from [Portfolio Project].dbo.NashvilleHousing

--Updating the table
Update [Portfolio Project].dbo.NashvilleHousing
Set SoldAsVacant = case
   when SoldAsVacant = 'Y' then 'Yes'
   when soldAsVacant = 'N' then 'No'
   Else SoldAsVacant
   End



   --Deleting Duplicates
   ---We create a CTE table and then query to get the duplicates
   --We can also delete the duplicates from the outcome of our query

   With RowNumCTE as(
   Select*,
   ROW_NUMBER() over (
     Partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				    UniqueID
					)  Row_num
   from [Portfolio Project].dbo.NashvilleHousing
   --Order by ParcelID
   )
   Select*
   From RowNumCTE
   where Row_num >1
   --Order by PropertyAddress


 -- Deleting Unused Columns

 Select *
  from [Portfolio Project].dbo.NashvilleHousing

  Alter Table [Portfolio Project].dbo.NashvilleHousing
  Drop Column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate