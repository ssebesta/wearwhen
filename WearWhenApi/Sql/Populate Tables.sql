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


select * from Outfit

insert into Outfit (Description, AccountId) values ('My Test Outfit #1', 1)

select * from Account