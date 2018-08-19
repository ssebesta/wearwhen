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

        public override Contact Add(Contact contact)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                contact = conn.Query<Contact>("Add" + _entityName, new { name = contact.Name, accountId = contact.AccountId }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return contact;
        }

        public override Contact Update(Contact contact)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                contact = conn.Query<Contact>("Update" + _entityName, new { name = contact.Name }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return contact;
        }

    }
}
