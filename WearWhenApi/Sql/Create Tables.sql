/*
drop table ClothingItemActivity
drop table ActivityType
drop table Contact
drop table Designer
drop table ClothingItemType
drop table ClothingItem
drop table Account
*/

/*
create database WearWhen

create login wearadmin with password='w3aR20!8'
*/

use WearWhen
go

create table Account (
	Id int identity(1,1),
	FirstName nvarchar(100) not null,
	MiddleName nvarchar(100) null,
	LastName nvarchar(100) not null,
	Email nvarchar(100) not null,
	Username nvarchar(100) not null,
	PasswordHash nvarchar(500) not null,
	Salt nvarchar(255) not null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_Account_Id primary key clustered (Id asc)	
)
go

create table Designer (
	Id int identity(1,1),
	[Name] nvarchar(255) not null,
	AccountId int null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_Designer_Id primary key clustered (Id asc),
	constraint FK_Designer_Account foreign key (AccountId) references Account (Id)
)
go

create table ClothingItemType (
	Id int identity(1,1),
	[Name] nvarchar(255) not null,
	AccountId int null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_ClothingItemType_Id primary key clustered (Id asc),
	constraint FK_ClothingItemType_Account foreign key (AccountId) references Account (Id)
)
go

create table ClothingItemSubType (
	Id int identity(1,1),
	ClothingItemTypeId int not null,
	[Name] nvarchar(100) not null,
	AccountId int null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_ClothingItemSubType_Id primary key clustered (Id asc),
	constraint FK_ClothingItemSubType_ClothingItemType foreign key (ClothingItemTypeId) references ClothingItemType (Id),
	constraint FK_ClothingItemSubType_Account foreign key (AccountId) references Account (Id)
)
go

create table ClothingItem (
	Id int identity(1,1),
	AccountId int not null,
	[Description] nvarchar(100) not null,
	DesignerId int null,
	ClothingItemTypeId int null,
	ClothingItemSubTypeId int null,
	PlaceOfPurchase nvarchar(255) null,
	DateOfPurchase date null,
	PricePaid decimal(19,4) null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_ClothingItem_Id primary key clustered (Id asc),
	constraint FK_ClothingItem_Designer foreign key (DesignerId) references Designer (Id),
	constraint FK_ClothingItem_Account foreign key (AccountId) references Account (Id),
	constraint FK_ClothingItem_ClothingItemType foreign key (ClothingItemTypeId) references ClothingItemType (Id),
	constraint FK_ClothingItem_ClothingItemSubType foreign key (ClothingItemSubTypeId) references ClothingItemSubType (Id)
)
go

create table Outfit (
	Id int identity(1,1),
	[Description] nvarchar(100) not null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	AccountId int not null,
	constraint PK_Outfit_Id primary key clustered (Id asc),
	constraint FK_Outfit_Account foreign key (AccountId) references Account (Id)	
)
go

create Table OutfitXClothingItem (
	Id int identity(1,1),
	OutfitId int not null,
	ClothingItemId int not null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_OutfitXClothingItem_Id primary key clustered (Id asc),
	constraint FK_OutfitXClothingItem_Outfit foreign key (OutfitId) references Outfit (Id),
	constraint FK_OutfitXClothingItem_ClothingItem foreign key (ClothingItemId) references ClothingItem (Id)
)
go

create table Contact (
	Id int identity(1,1),
	[Name] nvarchar(255) not null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	AccountId int not null,
	constraint PK_Contact_Id primary key clustered (Id asc),
	constraint FK_Contact_Account foreign key (AccountId) references Account (Id)	
)
go

create table ActivityType (
	Id int identity(1,1),
	[Name] nvarchar(50) not null,
	AccountId int null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_ActivityType_Id primary key clustered (Id asc),
	constraint FK_ActivityType_Account foreign key (AccountId) references Account (Id)	
)
go


create table ItemActivity (
	Id int identity(1,1),
	ClothingItemId int null,
	OutfitId int null,
	ActivityTypeId int not null,
	ContactId int null,
	ActivityDate date not null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_ItemActivity_Id primary key clustered (Id asc),
	constraint FK_ItemActivity_ClothingItem foreign key (ClothingItemId) references ClothingItem (Id),
	constraint FK_itemActivity_Outfit foreign key (OutfitId) references Outfit (Id),	
	constraint FK_ItemActivity_Contact foreign key (ContactId) references Contact (Id),
	constraint FK_ItemActivity_ActivityType foreign key (ActivityTypeId) references ActivityType (Id)
)
go

create proc AddAccount (
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
GO
grant execute on AddAccount to public
GO

create proc AddClothingItem (
	@accountId int,
	@description nvarchar(100),
	@designerId int,
	@clothingItemTypeId int,
	@clothingItemSubTypeId int,
	@placeOfPurchase nvarchar(255),
	@dateOfPurchase date,
	@pricePaid decimal(19,4),
	@outfitId int = null
)
as
begin

	insert into ClothingItem (AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, 
														PlaceOfPurchase, DateOfPurchase, PricePaid)
							      values (@accountId, @description, @designerId, @clothingItemTypeId, @clothingItemSubTypeId,
												    @placeOfPurchase, @dateOfPurchase, @pricePaid)

	declare @id int;

	select @id = cast(SCOPE_IDENTITY() as int)

	if (@outfitId != null)
	begin

		insert into OutfitXClothingItem (OutfitId, ClothingItemId) values (@outfitId, @id)

	end

	select Id, AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, 
		PlaceOfPurchase, DateOfPurchase, PricePaid
	from ClothingItem
	where Id = @id

end
GO
grant execute on AddClothingItem to public
go

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
go
grant execute on AddContact to public
go

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
go
grant execute on AddDesigner to public
go

create proc AddItemActivity (
	@clothingItemId int,
	@outfitId int,
	@activityTypeId int,
	@contactId int,
	@activityDate date
)
as
begin

	insert into ItemActivity (ClothingItemId, OutfitId, ActivityTypeId, ContactId, ActivityDate)
	values (@clothingItemId, @outfitId, @activityTypeId, @contactId, @activityDate)

	declare @id int

	select @id = cast(SCOPE_IDENTITY() as int)

	select a.Id, a.ClothingItemId, a.OutfitId, a.ActivityTypeId, t.Name as ActivityTypeName, a.ContactId, a.ActivityDate, a.CreatedDateTime
	from ItemActivity a
		inner join ActivityType t on (a.ActivityTypeId = t.Id)
	where a.Id = @id

end
go
grant execute on AddItemActivity to public
go

create proc AddOutfit (
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
go
grant execute on AddOutfit to public
go

create proc AuthenticateAccount (
	@username nvarchar(100),
	@passwordHash nvarchar(100)
)
as
begin

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime
	from Account
	where Username = @username
		and PasswordHash = @passwordHash

end
go
grant execute on AuthenticateAccount to public
GO

create proc GetAccount (
	@id int
)
as
begin

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime
	from Account
	where Id = @id

end
go
grant execute on GetAccount to public
go

create proc GetAccountSalt (
	@username nvarchar(100),
	@salt nvarchar(255) output
)
as
begin

	select @salt = Salt
	from Account
	where Username = @username

end
go
grant execute on GetAccountSalt to public
go

create proc GetClothingItem (
	@id int
)
as
begin

	select ci.Id, ci.AccountId, ci.Description, ci.DesignerId, ci.ClothingItemTypeId, t.Name as ClothingItemTypeName,
		ci.ClothingItemSubTypeId, st.Name as ClothingItemSubTypeName, ci.PlaceOfPurchase, ci.DateOfPurchase, ci.PricePaid,
		ci.CreatedDateTime, ci.LastUpdateDateTime
	from ClothingItem ci
	  left outer join ClothingItemType t on (t.Id = ci.ClothingItemTypeId)
		left outer join ClothingItemSubType st on (st.Id = ci.ClothingItemSubTypeId)
	where ci.Id = @id

end
go
grant execute on GetClothingItem to public
go


