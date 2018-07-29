create proc GetContact (
	@id int
)
as
begin

	select Id, Name, CreatedDateTime, AccountId, LastUpdateDateTime
	from Contact
	where Id = @id

end

grant execute on GetContact to public