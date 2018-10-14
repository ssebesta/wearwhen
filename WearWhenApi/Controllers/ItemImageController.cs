using System;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Models;
using WearWhenApi.Repositories;
using WearWhenApi.Utils;

namespace WearWhenApi.Controllers
{
    [Route("api/[controller]")]
    public class ItemImageController : Controller
    {
        //public ItemImageController(IRepository<ItemImage> itemImageRepository) : base(itemImageRepository) { }

        [HttpGet("download/{accountid}/{itemtype}/{itemid}/{filename}")]
        public IActionResult Download(int accountId, string itemType, int itemId, string fileName)
        {
            string filePath = String.Format("WearWhenImages/Accounts/{0}/{1}/{2}/{3}", accountId, itemType, itemId, fileName);

            var item = FileDownloader.GetFile(filePath);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }
    }
}
