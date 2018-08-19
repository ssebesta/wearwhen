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
            // TODO: _config.DefaultConnection keeps coming back null, but only on the Mac; works fine
            // in VS2017 on a PC.  Need to troubleshoot.
            //SqlConnection conn = new SqlConnection(_config.DefaultConnection);
            SqlConnection conn = new SqlConnection("server=localhost;database=WearWhen;user=wearadmin;pwd=w3aR20!8");
            conn.Open();

            return conn;            
        }

    }
}
