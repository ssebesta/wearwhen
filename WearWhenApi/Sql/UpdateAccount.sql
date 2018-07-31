alter proc UpdateAccount (
	@id int,
	@firstName nvarchar(100),
	@middleName nvarchar(100),
	@lastName nvarchar(100),
	@email nvarchar(100),
	@username nvarchar(100)
)
as
begin

	update Account
	set FirstName = @firstName,
		MiddleName = @middleName,
		LastName = @lastName,
		Email = @email,
		Username = @username,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime, Salt, PasswordHash, LastUpdateDateTime
	from Account
	where Id = @id	

end

grant execute on UpdateAccount to publi

