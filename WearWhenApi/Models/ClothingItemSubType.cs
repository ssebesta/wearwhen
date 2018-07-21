using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WearWhenApi.Models
{
    public class ClothingItemSubType : BaseModel
    {
        public string Name { get; set; }
        public ClothingItemType ClothingItemType { get; set; }
        public Account Account { get; set; }        
    }
}
