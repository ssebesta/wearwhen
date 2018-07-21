using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Models;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using WearWhenApi.Data;

namespace WearWhenApi.Repositories
{
    public class AccountRepository : Repository<Account>, IAccountRepository
    {        
        public AccountRepository(IDbConnectionFactory connFactory) : base(connFactory)
        {
            _entityName = "Account";
            _entityNamePlural = "Accounts";
        }

        public AuthenticateAccountResult AuthenticateAccount(string un, string pw)
        {
            AuthenticateAccountResult result = new AuthenticateAccountResult()
            {
                Success = false,
                ErrorMessage = "Invalid username or password."
            };

            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                var p = new DynamicParameters();
                p.Add("username", un, DbType.String, ParameterDirection.Input);
                p.Add("salt", dbType: DbType.String, direction: ParameterDirection.Output, size: 255);

                conn.Query<string>("GetAccountSalt", p, commandType: CommandType.StoredProcedure);

                string saltString = p.Get<string>("salt");

                if (!String.IsNullOrEmpty(saltString))
                {
                    byte[] salt = Convert.FromBase64String(saltString);

                    string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                        password: pw,
                        salt: salt,
                        prf: KeyDerivationPrf.HMACSHA1,
                        iterationCount: 10000,
                        numBytesRequested: 256 / 8));

                    Account authenticatedAccount = conn.Query<Account>("AuthenticateAccount", new { username = un, passwordHash = hashed }, commandType: CommandType.StoredProcedure).FirstOrDefault();

                    if (authenticatedAccount != null)
                    {
                        result.Success = true;
                        result.ErrorMessage = "";
                        result.Account = authenticatedAccount;
                    }
                }
            }                

            return result;
        }

        public Account CreateAccount(dynamic content)
        {
            Account newAccount = null;

            string contentString = content.ToString();
            Dictionary<string, string> accountInfo = JsonConvert.DeserializeObject<Dictionary<string, string>>(contentString);

            string password = accountInfo["password"];

            // generate a 128-bit salt using a secure PRNG
            byte[] salt = new byte[128 / 8];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            // derive a 256-bit subkey (use HMACSHA1 with 10,000 iterations)
            string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                password: password,
                salt: salt,
                prf: KeyDerivationPrf.HMACSHA1,
                iterationCount: 10000,
                numBytesRequested: 256 / 8));

            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                newAccount = conn.Query<Account>("CreateAccount", new { username = accountInfo["username"],
                                                                        firstName = accountInfo["firstName"],
                                                                        middleName = accountInfo["middleName"],
                                                                        lastName = accountInfo["lastName"],
                                                                        email = accountInfo["email"],
                                                                        passwordHash = hashed,
                                                                        salt = Convert.ToBase64String(salt)
                                                                      }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return newAccount;
        }
    }
}
