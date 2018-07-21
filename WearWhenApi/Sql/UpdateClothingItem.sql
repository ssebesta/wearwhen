create proc UpdateClothingItem (
	@id int,
	@description nvarchar(100),
	@designerId int,
	@clothingItemTypeId int,
	@clothingItemSubTypeId int,
	@placeOfPurchase nvarchar(255),
	@dateOfPurchase date,
	@pricePaid decimal(19,4)
)
as
begin

	update ClothingItem
	set Description = @description, 
		DesignerId = @designerId, 
		ClothingItemTypeId = @clothingItemTypeId, 
		ClothingItemSubTypeId = @clothingItemSubTypeId, 
		PlaceOfPurchase = @placeOfPurchase, 
		DateOfPurchase = @dateOfPurchase, 
		PricePaid = @pricePaid
	where Id = @id

	select Id, AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, 
		PlaceOfPurchase, DateOfPurchase, PricePaid, CreatedDateTime, LastUpdateDateTime
	from ClothingItem
	where Id = @id

end

grant execute on UpdateClothingItem to public
