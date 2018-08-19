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
        private IRepository<Contact> _contactRepository;

        public ItemActivityRepository(IDbConnectionFactory connFactory, IRepository<Contact> contactRepository) : base(connFactory)
        {
            _contactRepository = contactRepository;
        }

        public override ItemActivity Add(ItemActivity itemActivity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                itemActivity = conn.Query<ItemActivity>("Add" + _entityName,
                                                  new
                                                  {
                                                      clothingItemId = itemActivity.ClothingItemId,
                                                      outfitId = itemActivity.OutfitId,
                                                      activityTypeId = itemActivity.ActivityTypeId,
                                                      contactId = itemActivity.ContactId,
                                                      activityDate = itemActivity.ActivityDate
                                                  },
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();

                GetAdditionalEntityData(itemActivity, conn);
            }           

            return itemActivity;
        }

        public override ItemActivity Update(ItemActivity itemActivity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                itemActivity = conn.Query<ItemActivity>("Update" + _entityName,
                                                  new
                                                  {
                                                      id = itemActivity.Id,
                                                      clothingItemId = itemActivity.ClothingItemId,
                                                      outfitId = itemActivity.OutfitId,
                                                      activityTypeId = itemActivity.ActivityTypeId,
                                                      contactId = itemActivity.ContactId,
                                                      activityDate = itemActivity.ActivityDate
                                                  },
                                                  commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return itemActivity;
        }

        protected override void GetAdditionalEntityData(ItemActivity itemActivity, SqlConnection conn)
        {
            if (itemActivity.ContactId != null)
            {
                itemActivity.Contact = _contactRepository.Get((int)itemActivity.ContactId);
            }
        }
    }
}
