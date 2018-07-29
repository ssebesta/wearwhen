using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Models;
using WearWhenApi.Repositories;
using Newtonsoft.Json;

namespace WearWhenApi.Controllers
{
    [Route("api/[controller]")]
    public class BaseController<T>: Controller where T: BaseModel
    {
        protected IRepository<T> _repository;

        public BaseController(IRepository<T> repository)
        {
            _repository = repository;
        }

        [HttpGet("all/{parentId}")]
        public IActionResult GetAll(int parentId)
        {
            var item = _repository.GetAll(parentId);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            var item = _repository.Get(id);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }
                  
        /// <summary>
        /// Add an entity to the database with an optional parent Id specified
        /// </summary>
        /// <param name="entity">The entity to add</param>
        /// <param name="parentId">The parent Id of the entity.  Only specified if the entity is parented through a many
        /// to many relationship; otherwise, the parent is specified as part of the model.</param>
        /// <returns></returns>
        [HttpPost]        
        public IActionResult Add([FromBody] T entity, [FromQuery] int? parentId)
        {
            T item;

            if (parentId != null)
            {
                item = _repository.Add(entity, (int)parentId);
            }
            else
            {
                item = _repository.Add(entity);
            }

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }         

        [HttpPut]
        public IActionResult Update([FromBody] T entity)
        {
            var item = _repository.Update(entity);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

    }
}
