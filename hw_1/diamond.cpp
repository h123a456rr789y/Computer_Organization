#include <iostream>
using namespace std;

int main()
{
    int n;
    cin >> n;

    for(int i=1; i<=n; i++)
    {
        for(int j=1; j<=n-i; j++)
        {
            printf(" ");
        }
        for(int j=n-i+1; j<n+i; j++)
        {
            printf("*");
        }
        printf("\n");
    }

    for(int i=n-1; i>=1; i--)
    {
        for(int j=1; j<=(n-i); j++)
        {
            printf(" ");
        }
        for(int j=n-i+1; j<n+i; j++)
        {
            printf("*");
        }
        printf("\n");
    }

    return 0;
}




