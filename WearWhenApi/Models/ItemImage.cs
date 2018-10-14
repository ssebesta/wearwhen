using System;
namespace WearWhenApi.Models
{
	public class ItemImage : BaseModel
    {
        public string ImageName { get; set; }
        public int ClothingItemId { get; set; }
        public int OutfitId { get; set; }

        public ItemImage()
        {
        }
    }
}
