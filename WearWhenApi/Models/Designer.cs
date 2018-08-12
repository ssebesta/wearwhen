using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WearWhenApi.Models
{
    public class Designer : BaseModel
    {
        public string Name { get; set; }
        public int AccountId { get; set; }
        public Account Account { get; set; }        
    }
}
