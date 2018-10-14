using Dapper;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using WearWhenApi.Data;
using WearWhenApi.Models;
                 
namespace WearWhenApi.Repositories
{
    public class ItemImageRepository : Repository<ItemImage>, IRepository<ItemImage>
    {
        public ItemImageRepository(IDbConnectionFactory connFactory) : base(connFactory) {}

        public override ItemImage Add(ItemImage entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<ItemImage>("Add" + _entityName,
                                                new
                                                {
                                                    clothingItemId = entity.ClothingItemId,
                                                    outfitId = entity.OutfitId,
                                                    imageName = entity.ImageName
                                                },
                                                commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
        }
    }
}
