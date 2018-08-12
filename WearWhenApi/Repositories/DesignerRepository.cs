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
    public class DesignerRepository : Repository<Designer>
    {
        public DesignerRepository(IDbConnectionFactory connFactory) : base(connFactory)
        {
            _entityName = "Designer";
            _entityNamePlural = "Designers";
        }

        public override Designer Add(Designer designer)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                designer = conn.Query<Designer>("Add" + _entityName, new { name = designer.Name, accountId = designer.AccountId }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return designer;
        }

        public override Designer Update(Designer designer)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                designer = conn.Query<Designer>("Update" + _entityName, new { id = designer.Id, name = designer.Name }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return designer;
        }
    }
}
