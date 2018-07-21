alter proc AddOutfit (
	@description nvarchar(100),
	@accountId int
)
as
begin

	insert into Outfit (Description, AccountId)
							values (@description, @accountId)

	declare @id int;

	select @id = cast(SCOPE_IDENTITY() as int)

	select Id, Description, AccountId, CreatedDateTime
	from Outfit
	where Id = @id

end

grant execute on AddOutfit to public

