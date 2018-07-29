using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WearWhenApi.Models
{
    public class ClothingItem : BaseModel
    {      
        public string AccountId { get; set; }
        public Account Account { get; set; }
        public string Description { get; set; }
        public int? DesignerId { get; set; }
        public string DesignerName { get; set; }
        public int ClothingItemTypeId { get; set; }
        public string ClothingItemTypeName { get; set; }
        public int? ClothingItemSubTypeId { get; set; }
        public string ClothingItemSubTypeName { get; set; }
        public string PlaceOfPurchase { get; set; }
        public DateTime DateOfPurchase { get; set; }
        public decimal PricePaid { get; set; }

        public ICollection<Outfit> Outfits { get; set; }
        public ICollection<ItemActivity> ItemActivities { get; set; }
    }
}
