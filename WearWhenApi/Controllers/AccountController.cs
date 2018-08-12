using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Models;
using WearWhenApi.Repositories;

namespace WearWhenApi.Controllers
{
    public class AccountController : BaseController<Account>
    {
        public AccountController(IAccountRepository accountRepository): base(accountRepository) { }

        [HttpGet("authenticate/{un}/{pw}")]
        public IActionResult AuthenticateAccount(string un, string pw)
        {
            string username = WebUtility.HtmlDecode(un);
            string password = WebUtility.HtmlDecode(pw);

            var item = (_repository as IAccountRepository).AuthenticateAccount(username, password);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }
       
    }

}