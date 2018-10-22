#include <iostream>
#include <math.h>
using namespace std;
int mod_op(int x, int y, int n){
    if (y == 0)
        return 1;

    if (y%2 == 0)
        return (mod_op(x, floor(y/2), n)*mod_op(x, floor(y/2), n))%n;
    else
        return ((x%n)*mod_op(x, floor(y/2), n)*mod_op(x, floor(y/2), n))%n;
}

int main(){
    int a,b,m;
    cin>> a;
    cin>> b;
    cin>> m;
    cout<< mod_op(a, b, m)<< endl;

    return 0;
}
