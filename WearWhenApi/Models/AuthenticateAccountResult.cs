using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace WearWhenApi.Models
{
    public class AuthenticateAccountResult
    {
        public int Id { get; set; }
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public Account Account { get; set; }
    }
}
