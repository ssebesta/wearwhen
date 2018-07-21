alter proc AuthenticateAccount (
	@username nvarchar(100),
	@passwordHash nvarchar(100)
)
as
begin

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime
	from Account
	where Username = @username
		and PasswordHash = @passwordHash

end

grant execute on AuthenticateAccount to public
