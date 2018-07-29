create proc UpdateDesigner (
	@id int,
	@name nvarchar(255)
)
as
begin

	update Designer
	set Name = @name,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, Name, CreatedDateTime, LastUpdateDateTime, AccountId
	from Designer
	where Id = @id

end

grant execute on UpdateDesigner to public