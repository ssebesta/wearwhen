using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Models;
using WearWhenApi.Repositories;

namespace WearWhenApi.Controllers
{
    public class ItemActivityController: BaseController<ItemActivity>
    {
        public ItemActivityController(IRepository<ItemActivity> itemActivityRepository): base(itemActivityRepository) { }
    }
}
