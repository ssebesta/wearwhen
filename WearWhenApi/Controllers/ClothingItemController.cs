using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Repositories;
using WearWhenApi.Models;
using Newtonsoft.Json;


namespace WearWhenApi.Controllers
{
    [Route("api/[controller]")]
    public class ClothingItemController : Controller
    {
        private IRepository<ClothingItem> _clothingItemRepository;

        public ClothingItemController(IRepository<ClothingItem> clothingItemRepository)
        {
            _clothingItemRepository = clothingItemRepository;
        }

        [HttpGet("all/{accountid}", Name = "GetAllByAccountId")]
        public IActionResult GetAllByAccountId(int accountId)
        {
            var item = _clothingItemRepository.GetAll(accountId);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpGet("{id}", Name = "GetById")]
        public IActionResult GetById(int id)
        {
            var item = _clothingItemRepository.Get(id);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPost(Name = "AddClothingItem")]
        public IActionResult AddClothingItem([FromBody]dynamic content)
        {
            ClothingItem clothingItem = JsonConvert.DeserializeObject<ClothingItem>(content.ToString());

            var item = _clothingItemRepository.Add(clothingItem);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPut(Name = "UpdateClothingItem")]
        public IActionResult UpdateClothingItem([FromBody]dynamic content)
        {
            ClothingItem clothingItem = JsonConvert.DeserializeObject<ClothingItem>(content.ToString());

            var item = _clothingItemRepository.Update(clothingItem);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }
    }
}
