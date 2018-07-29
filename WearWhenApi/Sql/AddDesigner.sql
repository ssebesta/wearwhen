create proc AddDesigner (
	@accountId int,
	@name nvarchar(255)
)
as
begin

	insert into Designer (Name, AccountId) values (@name, @accountId)

	select Id, Name, CreatedDateTime
	from Designer
	where Id = SCOPE_IDENTITY()

end

grant execute on AddDesigner to public
