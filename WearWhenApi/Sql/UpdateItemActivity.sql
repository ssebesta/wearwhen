alter proc UpdateItemActivity (
	@id int,
	@clothingItemId int,
	@outfitId int,
	@activityTypeId int,
	@contactId int,
	@activityDate date
)
as
begin

	update ItemActivity
	set ClothingItemId = @clothingItemId,
		OutfitId = @outfitId,
		ActivityTypeId = @activityTypeId,
		ContactId = @contactId,
		ActivityDate = @activityDate,
		LastUpdateDateTime = getdate()
	where Id = @id

	select a.Id, a.ClothingItemId, a.OutfitId, a.ActivityTypeId, t.Name as ActivityTypeName, a.ContactId, a.ActivityDate, a.CreatedDateTime, a.LastUpdateDateTime
	from ItemActivity a
		inner join ActivityType t on (a.ActivityTypeId = t.Id)
	where a.Id = @id

end

grant execute on UpdateItemActivity to public