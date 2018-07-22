using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Repositories;
using WearWhenApi.Models;
using Newtonsoft.Json;

namespace WearWhenApi.Controllers
{
    public class OutfitController: BaseController<Outfit>
    {
        public OutfitController(IRepository<Outfit> outfitRepository): base(outfitRepository)
        {

        }
        
    }
}
