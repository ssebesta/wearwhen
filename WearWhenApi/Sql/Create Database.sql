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
go
create login wearadmin with password='w3aR20!8'
go
create user wearadmin for login wearadmin
go
EXEC sp_addrolemember N'db_owner', N'wearadmin'
go
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

create table ItemImage (
    Id int identity(1,1),
    ImageName nvarchar(255) not null,
    ClothingItemId int null,
	OutfitId int null,
	CreatedDateTime datetime not null default(getdate()),
	LastUpdateDateTime datetime,
	constraint PK_ItemImage_Id primary key clustered (Id asc),
	constraint FK_ItemImage_ClothingItem foreign key (ClothingItemId) references ClothingItem (Id),
	constraint FK_itemImage_Outfit foreign key (OutfitId) references Outfit (Id)
)

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

create proc AddItemImage (
    @imageName nvarchar(255),
    @outfitId int = null,
    @clothingItemId int = null
)
as
begin

    insert into ItemImage (ImageName, OutfitId, ClothingItemId) values (@imageName, @outfitId, @clothingItemId)

    select Id, ImageName, OutfitId, ClothingItemId, CreatedDateTime
    from ItemImage
    where Id = SCOPE_IDENTITY()

end
go
grant execute on AddItemImage to public
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

create proc GetClothingItemActivities (
	@clothingItemId int
)
as
begin

	select Id, ClothingItemId, ActivityTypeId, ContactId, ActivityDate, CreatedDateTime, LastUpdateDateTime
	from ItemActivity
	where ClothingItemId = @clothingItemId

end
go
grant execute on GetClothingItemActivities to public
go

create proc GetClothingItemActivityList (
	@clothingItemId int
)
as
begin

	select Id, ClothingItemId, ActivityTypeId, ContactId, ActivityDate, CreatedDateTime, LastUpdateDateTime
	from ItemActivity
	where ClothingItemId = @clothingItemId

end
go
grant execute on GetClothingItemActivityList to public
go

create proc GetClothingItemImages (
    @clothingItemId int
)
as
begin

    select Id, ClothingItemId, OutfitId, ImageName, CreatedDateTime, LastUpdateDateTime
    from ItemImage
    where ClothingItemId = @clothingItemId

end
GO
grant execute on GetClothingItemImages to PUBLIC
go

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
go
grant execute on GetClothingItemContacts to public
GO

create proc GetClothingItemList (
	@accountId int
)
as
begin

	select ci.Id, ci.AccountId, ci.Description, ci.DesignerId, ci.ClothingItemTypeId, t.Name as ClothingItemTypeName,
		ci.ClothingItemSubTypeId, st.Name as ClothingItemSubTypeName, ci.PlaceOfPurchase, ci.DateOfPurchase, ci.PricePaid,
		ci.CreatedDateTime, ci.LastUpdateDateTime
	from ClothingItem ci
	  left outer join ClothingItemType t on (t.Id = ci.ClothingItemTypeId)
		left outer join ClothingItemSubType st on (st.Id = ci.ClothingItemSubTypeId)
	where ci.AccountId = @accountId

end
go
grant execute on GetClothingItemList to public
go

create proc GetClothingItemOutfits (
	@clothingItemId int
)
as
begin

	select o.Id, o.Description, o.CreatedDateTime, o.AccountId, o.LastUpdateDateTime
	from OutfitXClothingItem x
		inner join Outfit o on (o.Id = x.OutfitId)
	where x.ClothingItemId = @clothingItemId

end
go
grant execute on GetClothingItemOutfits to public
GO

create proc GetContact (
	@id int
)
as
begin

	select Id, Name, CreatedDateTime, AccountId, LastUpdateDateTime
	from Contact
	where Id = @id

end
go
grant execute on GetContact to public
GO

create proc GetItemActivity (
	@id int
)
as
begin

	select ia.Id, ia.ClothingItemId, ia.OutfitId, ia.ActivityTypeId, a.Name as ActivityTypeName,
		ia.ContactId, ia.ActivityDate, ia.CreatedDateTime, ia.LastUpdateDateTime
	from ItemActivity ia
	  inner join ActivityType a on (ia.ActivityTypeId = a.Id)
	where ia.Id = @id

end
go
grant execute on GetItemActivity to public
GO

create proc GetOutfit (
	@id int
)
as
begin

	select Id, Description, CreatedDateTime, AccountId
	from Outfit
	where Id = @id

end
go
grant execute on GetOutfit to public
GO

create proc GetOutfitActivities (
	@outfitId int
)
as
begin

	select a.Id, a.OutfitId, a.ActivityTypeId, t.Name as ActivityTypeName, ContactId, a.ActivityDate, a.CreatedDateTime, a.LastUpdateDateTime
	from ItemActivity a
	  inner join ActivityType t on (a.ActivityTypeId = t.Id)
	where OutfitId = @outfitId

end
go
grant execute on GetOutfitActivities to public
GO

create proc GetOutfitImages (
    @outfitId int
)
as
begin

    select Id, ClothingItemId, OutfitId, ImageName, CreatedDateTime, LastUpdateDateTime
    from ItemImage
    where OutfitId = @outfitId

end
GO
grant execute on GetOutfitImages to PUBLIC
go

create proc GetOutfitClothingItems (
	@outfitId int
)
as
begin

	select ci.Id, ci.CreatedDateTime, ci.DateOfPurchase, ci.Description, ci.PlaceOfPurchase, ci.PricePaid,
		t.Id as ClothingItemTypeId, t.Name as ClothingItemTypeName, 
		st.Id as ClothingItemSubTypeId, st.Name as ClothingItemSubTypeName, 
		d.Id as DesignerId, d.Name as DesignerName
	from ClothingItem ci
		inner join OutfitXClothingItem x on (x.ClothingItemId = ci.id)
		inner join ClothingItemType t on (t.Id = ci.ClothingItemTypeId)
		left outer join ClothingItemSubType st on (st.Id = ci.ClothingItemSubTypeId)
		left outer join Designer d on (d.Id = ci.DesignerId)
	where x.OutfitId = @outfitId

end
go
grant execute on GetOutfitClothingItems to public
GO

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
go
grant execute on GetOutfitContacts to public
GO

create proc GetOutfitList (
	@parentId int
)
as
begin

	select Id, Description, CreatedDateTime
	from Outfit
	where AccountId = @parentId

end
go
grant execute on GetOutfitList to public
GO

create proc UpdateAccount (
	@id int,
	@firstName nvarchar(100),
	@middleName nvarchar(100),
	@lastName nvarchar(100),
	@email nvarchar(100),
	@username nvarchar(100)
)
as
begin

	update Account
	set FirstName = @firstName,
		MiddleName = @middleName,
		LastName = @lastName,
		Email = @email,
		Username = @username,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime, Salt, PasswordHash, LastUpdateDateTime
	from Account
	where Id = @id	

end
go
grant execute on UpdateAccount to PUBLIC
GO

create proc UpdateAccountPassword (
	@id int,
	@passwordHash nvarchar(500),
	@salt nvarchar(255)
)
as
begin

	update Account
	set PasswordHash = @passwordHash,
		Salt = @salt,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, FirstName, MiddleName, LastName, Email, Username, CreatedDateTime, Salt, PasswordHash, LastUpdateDateTime
	from Account
	where Id = @id

end
go
grant execute on UpdateAccountPassword to public
GO

create proc UpdateClothingItem (
	@id int,
	@description nvarchar(100),
	@designerId int,
	@clothingItemTypeId int,
	@clothingItemSubTypeId int,
	@placeOfPurchase nvarchar(255),
	@dateOfPurchase date,
	@pricePaid decimal(19,4)
)
as
begin

	update ClothingItem
	set Description = @description, 
		DesignerId = @designerId, 
		ClothingItemTypeId = @clothingItemTypeId, 
		ClothingItemSubTypeId = @clothingItemSubTypeId, 
		PlaceOfPurchase = @placeOfPurchase, 
		DateOfPurchase = @dateOfPurchase, 
		PricePaid = @pricePaid
	where Id = @id

	select Id, AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, 
		PlaceOfPurchase, DateOfPurchase, PricePaid, CreatedDateTime, LastUpdateDateTime
	from ClothingItem
	where Id = @id

end
go
grant execute on UpdateClothingItem to public
GO

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
GO
grant execute on UpdateContact to public
GO

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
go
grant execute on UpdateDesigner to public
GO

create proc UpdateItemActivity (
	@id int,
	@clothingItemId int,
	@outfitId int,
	@activityTypeId int,
	@contactId int,
	@activityDate date
)
as
begin

	update ItemActivity
	set ClothingItemId = @clothingItemId,
		OutfitId = @outfitId,
		ActivityTypeId = @activityTypeId,
		ContactId = @contactId,
		ActivityDate = @activityDate,
		LastUpdateDateTime = getdate()
	where Id = @id

	select a.Id, a.ClothingItemId, a.OutfitId, a.ActivityTypeId, t.Name as ActivityTypeName, a.ContactId, a.ActivityDate, a.CreatedDateTime, a.LastUpdateDateTime
	from ItemActivity a
		inner join ActivityType t on (a.ActivityTypeId = t.Id)
	where a.Id = @id

end
go
grant execute on UpdateItemActivity to public
GO

create proc UpdateOutfit (
	@id int,
	@description nvarchar(100)
)
as
begin

	update Outfit
	set Description = @description,
		LastUpdateDateTime = getdate()
	where Id = @id

	select Id, Description, CreatedDateTime, AccountId
	from Outfit
	where Id = @id

end
go
grant execute on UpdateOutfit to public
GO

/*
truncate table ClothingItemActivity
truncate table ActivityType
truncate table Contact
truncate table Designer
delete from ClothingItemSubType
delete from ClothingItemType
truncate table ClothingItem
truncate table Account
*/

insert into Designer ([Name]) values ('Ralph Lauren')
insert into Designer ([Name]) values ('Express')
insert into Designer ([Name]) values ('Ann Taylor')
insert into Designer ([Name]) values ('Talbots')
insert into Designer ([Name]) values ('Banana Republic')
insert into Designer ([Name]) values ('Calvin Klein')
insert into Designer ([Name]) values ('Lucky Brand')
insert into Designer ([Name]) values ('The Gap')
insert into Designer ([Name]) values ('Zara')
insert into Designer ([Name]) values ('H & M')
insert into Designer ([Name]) values ('Dolce & Gabbana')

insert into ClothingItemType ([Name]) values ('Tops')
insert into ClothingItemType ([Name]) values ('Bottoms')
insert into ClothingItemType ([Name]) values ('Dresses')
insert into ClothingItemType ([Name]) values ('Shoes')
insert into ClothingItemType ([Name]) values ('Accessories')
insert into ClothingItemType ([Name]) values ('Undergarments')
insert into ClothingItemType ([Name]) values ('Outerwear')
insert into ClothingItemType ([Name]) values ('Jumpers/Rompers')
insert into ClothingItemType ([Name]) values ('Swimwear')

insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Blouses' from ClothingItemType where [Name] = 'Tops'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'T-Shirts' from ClothingItemType where [Name] = 'Tops'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Tanks/Camis' from ClothingItemType where [Name] = 'Tops'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Activewear' from ClothingItemType where [Name] = 'Tops'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Vests' from ClothingItemType where [Name] = 'Tops'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Sweaters' from ClothingItemType where [Name] = 'Tops'

insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Shorts' from ClothingItemType where [Name] = 'Bottoms'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Pants' from ClothingItemType where [Name] = 'Bottoms'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Jeans' from ClothingItemType where [Name] = 'Bottoms'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Skirts' from ClothingItemType where [Name] = 'Bottoms'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, 'Leggings' from ClothingItemType where [Name] = 'Bottoms'

insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, '' from ClothingItemType where [Name] = 'Shoes'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, '' from ClothingItemType where [Name] = 'Shoes'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, '' from ClothingItemType where [Name] = 'Shoes'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, '' from ClothingItemType where [Name] = 'Shoes'
insert into ClothingItemSubType (ClothingItemTypeId, [Name]) select Id, '' from ClothingItemType where [Name] = 'Shoes'

insert into ActivityType (Name) values ('Business Meeting')
insert into ActivityType (Name) values ('Meetup with Friends/Family')
insert into ActivityType (Name) values ('Date')

----------------
-- Test Data
----------------
insert into Account (FirstName, MiddleName, LastName, Email, Username, PasswordHash, Salt)
values ('Stephen', 'C', 'Sebesta', 'sebesta@wearwhen.com', 'ssebesta', 'LT0jpgCyTTrov3qfgOrID/j4NVX2EIJou9SzQkvBjcY=', 'MKnbEYrQA6hikmNgW+8tpw==')

insert into Outfit (Description, AccountId) values ('My favorite blue outfit', 1)

insert into ClothingItem (AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, PlaceOfPurchase, DateOfPurchase, PricePaid)
values (1, 'Blue Top', null, 1, null, 'Nordstrom Rack', '7/1/2018', 35)
insert into ClothingItem (AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, PlaceOfPurchase, DateOfPurchase, PricePaid)
values (1, 'Skinny Jeans', null, 1, null, 'Express', '6/15/2018', 90)
insert into ClothingItem (AccountId, Description, DesignerId, ClothingItemTypeId, ClothingItemSubTypeId, PlaceOfPurchase, DateOfPurchase, PricePaid)
values (1, 'Black heels', null, 1, null, 'Macy''s', '7/10/2018', 120)

insert into OutfitXClothingItem(OutfitId, ClothingItemId) values (1,1)
insert into OutfitXClothingItem(OutfitId, ClothingItemId) values (1,2)
insert into OutfitXClothingItem(OutfitId, ClothingItemId) values (1,3)

insert into Contact (Name, AccountId) values ('Jim Ratley', 1)
insert into Contact (Name, AccountId) values ('Jenny Smith', 1)
insert into Contact (Name, AccountId) values ('Mike Barnes', 1)

insert into ItemActivity (OutfitId, ActivityTypeId, ContactId, ActivityDate)
values (1, 1, 1, '7/19/2018')
insert into ItemActivity (OutfitId, ActivityTypeId, ContactId, ActivityDate)
values (1, 2, 2, '7/29/2018')
insert into ItemActivity (OutfitId, ActivityTypeId, ContactId, ActivityDate)
values (1, 3, 3, '8/15/2018')

insert into ItemImage (OutfitId, ImageName) values (1, 'IMG_122345.png')







