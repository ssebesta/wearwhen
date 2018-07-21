create proc UpdateOutfit (
	@id int,
	@description nvarchar(100)
)
as
begin

	update Outfit
	set Description = @description,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, Description, CreatedDateTime, AccountId
	from Outfit
	where Id = @id

end

grant execute on UpdateOutfit to public

