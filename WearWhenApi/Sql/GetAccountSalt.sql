alter proc GetAccountSalt (
	@username nvarchar(100),
	@salt nvarchar(255) output
)
as
begin

	select @salt = Salt
	from Account
	where Username = @username

end

grant execute on GetAccountSalt to public

select * from account where id = 8