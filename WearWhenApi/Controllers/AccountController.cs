using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WearWhenApi.Repositories;

namespace WearWhenApi.Controllers
{
    [Route("api/[controller]")]
    public class AccountController : Controller
    {        
        private IAccountRepository _accountRepository;

        public AccountController(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;
        }
                
        [HttpGet("authenticate/{un}/{pw}", Name = "AuthenticateAccount")]
        public IActionResult AuthenticateAccount(string un, string pw)
        {
            string username = WebUtility.HtmlDecode(un);
            string password = WebUtility.HtmlDecode(pw);

            var item = _accountRepository.AuthenticateAccount(username, password);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }

        [HttpPost(Name = "CreateAccount")]
        public IActionResult CreateAccount([FromBody]dynamic content)
        {
            var item = _accountRepository.CreateAccount(content);

            if (item == null)
            {
                return NotFound();
            }

            return new ObjectResult(item);
        }           
    }

}