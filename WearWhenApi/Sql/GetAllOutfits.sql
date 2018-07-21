create proc GetAllOutfits (
	@parentId int
)
as
begin

	select Id, Description, CreatedDateTime
	from Outfit
	where AccountId = @parentId

end

grant execute on GetAllOutfits to public
