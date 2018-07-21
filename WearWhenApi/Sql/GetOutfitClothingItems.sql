alter proc GetOutfitClothingItems (
	@outfitId int
)
as
begin

	select ci.Id, ci.CreatedDateTime, ci.DateOfPurchase, ci.Description, ci.PlaceOfPurchase, ci.PricePaid,
		t.Id as ClothingItemTypeId, t.Name as ClothingItemTypeName, 
		st.Id as ClothingItemSubTypeId, st.Name as ClothingItemSubTypeName, 
		d.Id as DesignerId, d.Name as DesignerName
	from ClothingItem ci
		inner join OutfitXClothingItem x on (x.ClothingItemId = ci.id)
		inner join ClothingItemType t on (t.Id = ci.ClothingItemTypeId)
		left outer join ClothingItemSubType st on (st.Id = ci.ClothingItemSubTypeId)
		left outer join Designer d on (d.Id = ci.DesignerId)
	where x.OutfitId = @outfitId

end

--grant execute on GetOutfitClothingItems to public