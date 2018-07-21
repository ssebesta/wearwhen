create proc GetOutfit (
	@id int
)
as
begin

	select Id, Description, CreatedDateTime, AccountId
	from Outfit
	where Id = @id

end

grant execute on GetOutfit to public

