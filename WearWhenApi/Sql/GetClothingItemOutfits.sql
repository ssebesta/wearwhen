alter proc GetClothingItemOutfits (
	@clothingItemId int
)
as
begin

	select o.Id, o.Description, o.CreatedDateTime, o.AccountId, o.LastUpdateDateTime
	from OutfitXClothingItem x
		inner join Outfit o on (o.Id = x.OutfitId)
	where x.ClothingItemId = @clothingItemId

end

grant execute on GetClothingItemOutfits to public