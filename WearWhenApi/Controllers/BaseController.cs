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

        [HttpGet("all/{parentId}", Name = "GetAll")]
        public IActionResult GetAll(int parentId)
        {
            var item = _repository.GetAll(parentId);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpGet("{id}", Name = "Get")]
        public IActionResult Get(int id)
        {
            var item = _repository.Get(id);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPost(Name = "Add")]
        public IActionResult Add([FromBody]dynamic content)
        {
            T entity = JsonConvert.DeserializeObject<T>(content.ToString());

            var item = _repository.Add(entity);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPut(Name = "Update")]
        public IActionResult Update([FromBody]dynamic content)
        {
            T entity = JsonConvert.DeserializeObject<T>(content.ToString());

            var item = _repository.Update(entity);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

    }
}
