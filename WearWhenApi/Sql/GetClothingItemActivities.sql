create proc GetClothingItemActivities (
	@clothingItemId int
)
as
begin

	select Id, ClothingItemId, ActivityTypeId, ContactId, ActivityDate, CreatedDateTime, LastUpdateDateTime
	from ItemActivity
	where ClothingItemId = @clothingItemId

end

grant execute on GetClothingItemActivities to public