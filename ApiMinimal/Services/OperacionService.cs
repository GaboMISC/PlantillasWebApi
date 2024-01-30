using ApiMinimal.Services.Contracts;

namespace ApiMinimal.Services
{
    public class OperacionService : IOperacionService
    {
        public int Addtion(int a, int b)
        {
            return a + b;
        }
    }
}