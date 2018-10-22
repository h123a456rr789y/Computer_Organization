#include<iostream>
using namespace std;
int main()
{
    int a,b,a_num[4],b_num[4],A = 0 ,B = 0;
    cout << "Input:"<<endl;
    cin >> a;
    for(int i = 0 ; i < 4 ; i++)
    {
        a_num[i] = a % 10;
        a = a / 10;
    }
    if(a_num[0] == a_num[1] || a_num[0] == a_num[2] || a_num[0] == a_num[3] ||
       a_num[1] == a_num[2] || a_num[1] == a_num[3] || a_num[2] == a_num[3])
    {
        cout << "ERROR" <<endl;
        return 0;
    }
    cin >> b;
    for(int i = 0 ; i < 4 ; i++)
    {
        b_num[i] = b % 10;
        b = b / 10;
    }
    if(b_num[0] == b_num[1] || b_num[0] == b_num[2] || b_num[0] == b_num[3] ||
       b_num[1] == b_num[2] || b_num[1] == b_num[3] || b_num[2] == b_num[3])
    {
        cout << "ERROR!" <<endl;
        return 0;
    }
    for(int i = 0 ; i < 4 ; i++)
    {
        if(a_num[i] == b_num[i])
            A++;
        for(int j = 0 ; j < 4 ; j++)
            if(a_num[i] == b_num[j] && i != j)
                B++;
    }
    cout << "Output:"<<endl << A << "A" << B << "B";
    return 0;
}
