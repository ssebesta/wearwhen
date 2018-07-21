using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WearWhenApi.Models
{
    public class BaseModel
    {
        public int Id { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime LastUpdateDateTime { get; set; }
    }
}
