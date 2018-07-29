create proc UpdateContact (
	@id int,
	@name nvarchar(255)	
)
as
begin

	update Contact
	set Name = @name,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, Name, AccountId, CreatedDateTime, LastUpdateDateTime
	from Contact
	where Id = @id

end

grant execute on UpdateContact to public