create proc GetClothingItemOutfits (
	@clothingItemId int
)
as
begin

	select o.Id, o.Description, o.CreatedDateTime
	from Outfit o
	  inner join OutfitXClothingItem x on (o.Id = x.OutfitId)
		inner join ClothingItem c on (x.ClothingItemId = c.Id)
	where c.Id = @clothingItemId

end

grant execute on GetClothingItemOutfits to public