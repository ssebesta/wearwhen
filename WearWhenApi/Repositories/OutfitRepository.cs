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
                entity.ClothingItems = conn.Query<ClothingItem>("GetOutfitClothingItems", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();

                entity.ItemActivities = conn.Query<ItemActivity>("GetOutfitActivities", new { outfitId = entity.Id }, commandType: CommandType.StoredProcedure).ToList();
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
