using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using WearWhenApi.Data;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public class ContactRepository: Repository<Contact>
    {
        public ContactRepository(IDbConnectionFactory connFactory) : base(connFactory) { }

        public override Contact Add(Contact entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<Contact>("Add" + _entityName, new { name = entity.Name, accountId = entity.AccountId }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
        }

        public override Contact Update(Contact entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<Contact>("Update" + _entityName, new { name = entity.Name }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return entity;
        }

    }
}
