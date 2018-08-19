using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using WearWhenApi.Data;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public class Repository<T> : IRepository<T> where T : BaseModel
    {
        protected IDbConnectionFactory _connectionFactory;
        protected string _entityName;   

        public Repository(IDbConnectionFactory connFactory)
        {            
            _connectionFactory = connFactory;
            _entityName = typeof(T).Name;
        }

        public virtual List<T> GetAll(int parentId)
        {
            List<T> entities = null;

            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entities = conn.Query<T>("Get" + _entityName + "List", new { parentId = parentId }, commandType: CommandType.StoredProcedure).ToList();
            }

            return entities;
        }

        public virtual T Get(int id)
        {
            T entity = null;

            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                entity = conn.Query<T>("Get" + _entityName, new { id = id }, commandType: CommandType.StoredProcedure).FirstOrDefault();

                GetAdditionalEntityData(entity, conn);
            }

            return entity;
        }
        
        public virtual T Add(T entity)
        {
            throw new NotImplementedException();
        }        

        public virtual T Add(T entity, int parentId)
        {
            throw new NotImplementedException();
        }

        public virtual T Update(T entity)
        {
            throw new NotImplementedException();
        }

        public virtual void Delete(T entity)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                conn.Execute("Delete" + _entityName, new { id = entity.Id }, commandType: CommandType.StoredProcedure);
            }
        }

        protected virtual void GetAdditionalEntityData(T entity, SqlConnection conn)
        {
            // Inherited class will implement
        }
    }
}
