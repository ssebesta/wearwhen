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

        protected override void GetAdditionalEntityData(ClothingItem clothingItem, SqlConnection conn)
        {
            if (clothingItem != null)
            {
                // Get outfits
                clothingItem.Outfits = conn.Query<Outfit>("GetClothingItemOutfits", new { clothingItemId = clothingItem.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get activities
                clothingItem.ItemActivities = conn.Query<ItemActivity>("GetClothingItemActivities", new { clothingItemId = clothingItem.Id }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public override ClothingItem Add(ClothingItem clothingItem)
        {
            return AddClothingItem(clothingItem);
        }

        public override ClothingItem Add(ClothingItem clothingItem, int outfitId)
        {
            return AddClothingItem(clothingItem, outfitId);
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

        public override ClothingItem Update(ClothingItem clothingItem)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                clothingItem = conn.Query<ClothingItem>("Update" + _entityName,
                                                  new
                                                  {
                                                      id = clothingItem.Id,
                                                      description = clothingItem.Description,
                                                      clothingItemTypeId = clothingItem.ClothingItemTypeId,
                                                      clothingItemSubTypeId = clothingItem.ClothingItemSubTypeId,
                                                      placeOfPurchase = clothingItem.PlaceOfPurchase,
                                                      dateOfPurchase = clothingItem.DateOfPurchase,
                                                      pricePaid = clothingItem.PricePaid
                                                  },
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();

                this.GetAdditionalEntityData(clothingItem, conn);
            }

            return clothingItem;
        }
    }
}
