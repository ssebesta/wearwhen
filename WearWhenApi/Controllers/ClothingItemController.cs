using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Repositories;
using WearWhenApi.Models;

namespace WearWhenApi.Controllers
{
    public class ClothingItemController : BaseController<ClothingItem>
    {
        public ClothingItemController(IRepository<ClothingItem> clothingItemRepository): base(clothingItemRepository) { }
    }
}
