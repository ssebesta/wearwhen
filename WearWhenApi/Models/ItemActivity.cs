using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WearWhenApi.Models
{
    public class ItemActivity : BaseModel
    {
        public int? ClothingItemId { get; set; }
        public ClothingItem ClothingItem { get; set; }
        public int? OutfitId { get; set; }
        public Outfit Outfit { get; set; }
        public int ActivityTypeId { get; set; }
        public string ActivityTypeName { get; set; }
        public int? ContactId { get; set; }
        public Contact Contact { get; set; }
        public DateTime ActivityDate { get; set; }        
    }
}
