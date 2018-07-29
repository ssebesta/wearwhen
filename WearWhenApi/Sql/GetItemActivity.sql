create proc GetItemActivity (
	@id int
)
as
begin

	select ia.Id, ia.ClothingItemId, ia.OutfitId, ia.ActivityTypeId, a.Name as ActivityTypeName,
		ia.ContactId, ia.ActivityDate, ia.CreatedDateTime, ia.LastUpdateDateTime
	from ItemActivity ia
	  inner join ActivityType a on (ia.ActivityTypeId = a.Id)
	where ia.Id = @id

end

grant execute on GetItemActivity to public