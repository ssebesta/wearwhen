create proc GetClothingItem (
	@id int
)
as
begin

	select ci.Id, ci.AccountId, ci.Description, ci.DesignerId, ci.ClothingItemTypeId, t.Name as ClothingItemTypeName,
		ci.ClothingItemSubTypeId, st.Name as ClothingItemSubTypeName, ci.PlaceOfPurchase, ci.DateOfPurchase, ci.PricePaid,
		ci.CreatedDateTime, ci.LastUpdateDateTime
	from ClothingItem ci
	  left outer join ClothingItemType t on (t.Id = ci.ClothingItemTypeId)
		left outer join ClothingItemSubType st on (st.Id = ci.ClothingItemSubTypeId)

end

grant execute on GetClothingItem to public