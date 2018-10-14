using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using WearWhenApi.Data;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public class OutfitRepository: Repository<Outfit>, IRepository<Outfit>
    {
        public OutfitRepository(IDbConnectionFactory connFactory) : base(connFactory) { }

        protected override void GetAdditionalEntityData(Outfit entity, SqlConnection conn)
        {
            if (entity != null)
            {
                // Get ClothingItems
                entity.ClothingItems = conn.Query<ClothingItem>("GetOutfitClothingItems", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get Activities
                entity.ItemActivities = conn.Query<ItemActivity>("GetOutfitActivities", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get Images
                entity.ItemImages = conn.Query<ItemImage>("GetOutfitImages", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                // Get contacts for the outfit's activities
                List<Contact> contacts = conn.Query<Contact>("GetOutfitContacts", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                foreach(ItemActivity itemActivity in entity.ItemActivities)
                {
                    if (itemActivity.ContactId != null)
                    {
                        itemActivity.Contact = contacts.Where(c => c.Id == itemActivity.ContactId).FirstOrDefault();
                    }
                }
            }
        }

        public override Outfit Add(Outfit entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {                
                entity = conn.Query<Outfit>("Add" + _entityName, new { description = entity.Description, accountId = entity.AccountId }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
        }

        public override Outfit Update(Outfit entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<Outfit>("Update" + _entityName, new { id = entity.Id, description = entity.Description }, commandType: CommandType.StoredProcedure).FirstOrDefault();

                GetAdditionalEntityData(entity, conn);
            }

            return entity;
        }

    }
}
