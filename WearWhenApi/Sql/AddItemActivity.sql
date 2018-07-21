Alter proc AddItemActivity (
	@clothingItemId int,
	@outfitId int,
	@activityTypeId int,
	@contactId int,
	@activityDate date
)
as
begin

	insert into ItemActivity (ClothingItemId, OutfitId, ActivityTypeId, ContactId, ActivityDate)
	values (@clothingItemId, @outfitId, @activityTypeId, @contactId, @activityDate)

	declare @id int

	select @id = cast(SCOPE_IDENTITY() as int)

	select a.Id, a.ClothingItemId, a.OutfitId, a.ActivityTypeId, t.Name as ActivityTypeName, a.ContactId, a.ActivityDate, a.CreatedDateTime
	from ItemActivity a
		inner join ActivityType t on (a.ActivityTypeId = t.Id)
	where a.Id = @id

end

grant execute on AddItemActivity to public