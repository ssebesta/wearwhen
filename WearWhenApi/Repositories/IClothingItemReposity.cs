using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public interface IClothingItemRepository : IRepository<ClothingItem>
    {
        ClothingItem Add(ClothingItem entity, int outfitId);
    }
}
