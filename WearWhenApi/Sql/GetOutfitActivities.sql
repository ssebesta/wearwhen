alter proc GetOutfitActivities (
	@outfitId int
)
as
begin

	select a.Id, a.OutfitId, a.ActivityTypeId, t.Name as ActivityTypeName, ContactId, a.ActivityDate, a.CreatedDateTime, a.LastUpdateDateTime
	from ItemActivity a
	  inner join ActivityType t on (a.ActivityTypeId = t.Id)
	where OutfitId = @outfitId

end

grant execute on GetOutfitActivities to public