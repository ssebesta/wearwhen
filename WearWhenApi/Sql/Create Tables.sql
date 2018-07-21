/*
drop table ClothingItemActivity
drop table ActivityType
drop table Contact
drop table Designer
drop table ClothingItemType
drop table ClothingItem
drop table Account
*/


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



