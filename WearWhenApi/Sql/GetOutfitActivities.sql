create proc GetOutfitActivities (
	@outfitId int
)
as
begin

	select Id, OutfitId, ActivityTypeId, ContactId, ActivityDate, CreatedDateTime, LastUpdateDateTime
	from ItemActivity
	where OutfitId = @outfitId

end

grant execute on GetOutfitActivities to public