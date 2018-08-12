--exec AddAccount 'x', '', 'y', 'y@y.com', 'y', 'lkjasdldfj', 'kjasjldffj'

alter proc AddAccount (
	@firstName nvarchar(100),
	@middleName nvarchar(100),
	@lastName nvarchar(100),
	@email nvarchar(100),
	@username nvarchar(100),
	@passwordHash nvarchar(500),
	@salt nvarchar(255)
)
as
begin

	insert into Account (FirstName, MiddleName, LastName, Email, Username, PasswordHash, Salt)
	values (@firstName, @middleName, @lastName, @email, @username, @passwordHash, @salt)

	declare @id int = cast(SCOPE_IDENTITY() as int)

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime, Salt, PasswordHash
	from Account
	where Id = @id

end

grant execute on AddAccount to public