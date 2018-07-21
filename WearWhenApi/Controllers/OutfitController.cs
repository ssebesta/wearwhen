using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Repositories;
using WearWhenApi.Models;
using Newtonsoft.Json;

namespace WearWhenApi.Controllers
{
    [Route("api/[controller]")]
    public class OutfitController: Controller
    {
        private IRepository<Outfit> _outfitRepository;

        public OutfitController(IRepository<Outfit> outfitRepository)
        {
            _outfitRepository = outfitRepository;
        }

        [HttpGet("all/{accountid}", Name = "GetAllByAccountId")]
        public IActionResult GetAllByAccountId(int accountId)
        {
            var item = _outfitRepository.GetAll(accountId);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpGet("{id}", Name = "GetById")]
        public IActionResult GetById(int id)
        {
            var item = _outfitRepository.Get(id);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPost(Name = "AddOutfit")]
        public IActionResult AddOutfit([FromBody]dynamic content)
        {
            Outfit outfit = JsonConvert.DeserializeObject<Outfit>(content.ToString());

            var item = _outfitRepository.Add(outfit);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPut(Name = "UpdateOutfit")]
        public IActionResult UpdateOutfit([FromBody]dynamic content)
        {
            Outfit outfit = JsonConvert.DeserializeObject<Outfit>(content.ToString());

            var item = _outfitRepository.Update(outfit);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }
    }
}
