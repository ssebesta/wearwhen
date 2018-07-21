create proc GetAccount (
	@id int
)
as
begin

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime
	from Account
	where Id = @id

end

grant execute on GetAccount to public