using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Models;

namespace WearWhenApi.Repositories
{
    public interface IAccountRepository : IRepository<Account>
    {
        AuthenticateAccountResult AuthenticateAccount(string un, string pw);
        Account CreateAccount(dynamic content);
    }
}
