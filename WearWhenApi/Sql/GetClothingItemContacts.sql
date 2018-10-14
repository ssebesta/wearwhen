create proc GetClothingItemContacts (
    @clothingItemId int
)
as
begin

    select c.Id, c.Name, c.CreatedDateTime, c.LastUpdateDateTime, c.AccountId
    from Contact c
        inner join ItemActivity a on (a.ContactId = c.Id)
    where a.ClothingItemId = @clothingItemId

end

grant execute on GetClothingItemContacts to public