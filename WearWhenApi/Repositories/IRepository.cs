using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public interface IRepository<T> where T: BaseModel
    {        
        List<T> GetAll(int parentId);
        T Get(int id);
        T Add(T entity);
        T Add(T entity, int parentId);
        T Update(T entity);
        void Delete(T entity);
    }
}
