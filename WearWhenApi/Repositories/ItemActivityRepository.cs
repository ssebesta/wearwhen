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
    public class ItemActivityRepository: Repository<ItemActivity>, IRepository<ItemActivity>
    {
        public ItemActivityRepository(IDbConnectionFactory connFactory) : base(connFactory)
        {
            _entityName = "ItemActivity";
            _entityNamePlural = "ItemActivities";
        }

        public override ItemActivity Add(ItemActivity entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<ItemActivity>("Add" + _entityName,
                                                  new
                                                  {
                                                      clothingItemId = entity.ClothingItemId,
                                                      outfitId = entity.OutfitId,
                                                      activityTypeId = entity.ActivityTypeId,
                                                      contactId = entity.ContactId,
                                                      activityDate = entity.ActivityDate
                                                  },
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
        }

        public override ItemActivity Update(ItemActivity entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<ItemActivity>("Update" + _entityName,
                                                  new
                                                  {
                                                      id = entity.Id,
                                                      clothingItemId = entity.ClothingItemId,
                                                      outfitId = entity.OutfitId,
                                                      activityTypeId = entity.ActivityTypeId,
                                                      contactId = entity.ContactId,
                                                      activityDate = entity.ActivityDate
                                                  },
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
        }
    }
}
