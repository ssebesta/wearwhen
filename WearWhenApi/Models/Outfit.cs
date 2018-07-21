using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WearWhenApi.Models
{
    public class Outfit : BaseModel
    {
        public string Description { get; set; }
        public int AccountId { get; set; }
        public Account Account { get; set; }        

        public ICollection<ClothingItem> ClothingItems { get; set; }
        public ICollection<ItemActivity> ItemActivities { get; set; }
    }
}
