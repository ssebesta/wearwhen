using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using WearWhenApi.Models;

using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using WearWhenApi.Data;
using WearWhenApi.Utils;

namespace WearWhenApi.Repositories
{
    public class AccountRepository : Repository<Account>, IAccountRepository
    {        
        public AccountRepository(IDbConnectionFactory connFactory) : base(connFactory) { }

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

                    string hashed = Crypto.CreatePasswordHash(salt, pw);

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

        public override Account Add(Account account)
        {
            byte[] salt = Crypto.CreateSalt();

            // derive a 256-bit subkey (use HMACSHA1 with 10,000 iterations)
            string hashed = Crypto.CreatePasswordHash(salt, account.Password);

            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                account = conn.Query<Account>("Add" + _entityName, new { username = account.Username,
                                                                         firstName = account.FirstName,
                                                                         middleName = account.MiddleName,
                                                                         lastName = account.LastName,
                                                                         email = account.Email,
                                                                         passwordHash = hashed,
                                                                         salt = Convert.ToBase64String(salt)
                                                                      }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return account;
        }

        public override Account Update(Account account)
        {
            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                account = conn.Query<Account>("Update" + _entityName, new
                                                                        {
                                                                            id = account.Id,
                                                                            username = account.Username,
                                                                            firstName = account.FirstName,
                                                                            middleName = account.MiddleName,
                                                                            lastName = account.LastName,
                                                                            email = account.Email,
                                                                        }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return account;
        }

        public Account UpdatePassword(Account account)
        {
            byte[] salt = Crypto.CreateSalt();

            string hashed = Crypto.CreatePasswordHash(salt, account.Password);


            using (SqlConnection conn = _connectionFactory.GetDbConnection())
            {
                account = conn.Query<Account>("Update" + _entityName, new
                                                                      {
                                                                        id = account.Id,
                                                                        passwordHash = hashed,
                                                                        salt = salt
                                                                      }, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }

            return account;
        }

    }
}
