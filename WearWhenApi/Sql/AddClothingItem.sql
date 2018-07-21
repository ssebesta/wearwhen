alter proc AddClothingItem (
	@accountId int,
	@description nvarchar(100),
	@designerId int,
	@clothingItemTypeId int,
	@clothingItemSubTypeId int,
	@placeOfPurchase nvarchar(255),
	@dateOfPurchase date,
	@pricePaid decimal(19,4),
	@outfitId int = null
)
as
begin

	insert into ClothingItem (AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, 
														PlaceOfPurchase, DateOfPurchase, PricePaid)
							      values (@accountId, @description, @designerId, @clothingItemTypeId, @clothingItemSubTypeId,
												    @placeOfPurchase, @dateOfPurchase, @pricePaid)

	declare @id int;

	select @id = cast(SCOPE_IDENTITY() as int)

	if (@outfitId != null)
	begin

		insert into OutfitXClothingItem (OutfitId, ClothingItemId) values (@outfitId, @id)

	end

	select Id, AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, 
		PlaceOfPurchase, DateOfPurchase, PricePaid
	from ClothingItem
	where Id = @id

end

grant execute on AddClothingItem to public