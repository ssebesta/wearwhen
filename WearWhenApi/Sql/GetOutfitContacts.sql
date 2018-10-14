create proc GetOutfitContacts (
    @outfitId int
)
as
begin

    select c.Id, c.Name, c.CreatedDateTime, c.LastUpdateDateTime, c.AccountId
    from Contact c
        inner join ItemActivity a on (a.ContactId = c.Id)
    where a.OutfitId = @outfitId

end

grant execute on GetOutfitContacts to public