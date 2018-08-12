create proc UpdateAccountPassword (
	@id int,
	@passwordHash nvarchar(500),
	@salt nvarchar(255)
)
as
begin

	update Account
	set PasswordHash = @passwordHash,
		Salt = @salt,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime, Salt, PasswordHash, LastUpdateDateTime
	from Account
	where Id = @id

end

grant execute on UpdateAccountPassword to public