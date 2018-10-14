using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Data;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public class ClothingItemRepository: Repository<ClothingItem>//, IRepository<ClothingItem>
    {
        public ClothingItemRepository(IDbConnectionFactory connFactory) : base(connFactory) { }

        protected override void GetAdditionalEntityData(ClothingItem entity, SqlConnection conn)
        {
            if (entity != null)
            {
                // Get outfits
                entity.Outfits = conn.Query<Outfit>("GetClothingItemOutfits", new { clothingItemId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get activities
                entity.ItemActivities = conn.Query<ItemActivity>("GetClothingItemActivities", new { clothingItemId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get Images
                entity.ItemImages = conn.Query<ItemImage>("GetClothingItemImages", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public override ClothingItem Add(ClothingItem entity)
        {
            return AddClothingItem(entity);
        }

        public override ClothingItem Add(ClothingItem entity, int outfitId)
        {
            return AddClothingItem(entity, outfitId);
        }

        private ClothingItem AddClothingItem(ClothingItem clothingItem, int? outfitId = null)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                clothingItem = conn.Query<ClothingItem>("Add" + _entityName,
                                                  new
                                                  {
                                                      accountId = clothingItem.AccountId,
                                                      description = clothingItem.Description,
                                                      clothingItemTypeId = clothingItem.ClothingItemTypeId,
                                                      clothingItemSubTypeId = clothingItem.ClothingItemSubTypeId,
                                                      placeOfPurchase = clothingItem.PlaceOfPurchase,
                                                      dateOfPurchase = clothingItem.DateOfPurchase,
                                                      pricePaid = clothingItem.PricePaid,
                                                      outfitId = outfitId
                                                  },
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return clothingItem;
        }

        public override ClothingItem Update(ClothingItem entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<ClothingItem>("Update" + _entityName,
                                                    new
                                                    {
                                                        id = entity.Id,
                                                        description = entity.Description,
                                                        clothingItemTypeId = entity.ClothingItemTypeId,
                                                        clothingItemSubTypeId = entity.ClothingItemSubTypeId,
                                                        placeOfPurchase = entity.PlaceOfPurchase,
                                                        dateOfPurchase = entity.DateOfPurchase,
                                                        pricePaid = entity.PricePaid
                                                    },
                                                    commandType: CommandType.StoredProcedure).FirstOrDefault();

                this.GetAdditionalEntityData(entity, conn);
            }

            return entity;
        }
    }
}
