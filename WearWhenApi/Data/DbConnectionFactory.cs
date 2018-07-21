using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using WearWhenApi.Data;

namespace WearWhenApi.Data
{    
    public class DbConnectionFactory : IDbConnectionFactory
    {
        private DbConfig _config;
        
        public DbConnectionFactory(IOptions<DbConfig> config)
        {
            _config = config.Value;
        }        

        public SqlConnection GetDbConnection()
        {
            SqlConnection conn = new SqlConnection(_config.DefaultConnection);            

            conn.Open();

            return conn;            
        }

    }
}
