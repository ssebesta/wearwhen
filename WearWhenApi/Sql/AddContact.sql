create proc AddContact (
	@name nvarchar(255),
	@accountId int
)
as
begin

	insert into Contact (Name, AccountId) values (@name, @accountId)

	declare @id int

	select Id, Name, AccountId, CreatedDateTime
	from Contact
	where Id = @id

end

grant execute on AddContact to public