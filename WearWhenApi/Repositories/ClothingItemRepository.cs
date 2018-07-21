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
    public class ClothingItemRepository: Repository<ClothingItem>, IClothingItemRepository
    {
        public ClothingItemRepository(IDbConnectionFactory connFactory) : base(connFactory)
        {
            _entityName = "ClothingItem";
            _entityNamePlural = "ClothingItems";
        }

        protected override void GetAdditionalEntityData(ClothingItem entity, SqlConnection conn)
        {
            if (entity != null)
            {
                // Get outfits
                entity.Outfits = conn.Query<Outfit>("GetClothingItemOutfits", new { clothingItemId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get activities
                entity.ItemActivities = conn.Query<ItemActivity>("GetClothingItemActivities", new { clothingItemId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public ClothingItem Add(ClothingItem entity, int outfitId)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<ClothingItem>("Add" + _entityName,
                                                  new
                                                  {
                                                      accountId = entity.AccountId,
                                                      description = entity.Description,
                                                      clothingItemTypeId = entity.ClothingItemTypeId,
                                                      clothingItemSubTypeId = entity.ClothingItemSubTypeId,
                                                      placeOfPurchase = entity.PlaceOfPurchase,
                                                      dateOfPurchase = entity.DateOfPurchase,
                                                      pricePaid = entity.PricePaid,
                                                      outfitId = outfitId
                                                  }, 
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
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
