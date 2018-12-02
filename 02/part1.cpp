#include <iostream>
#include <ctime>
#include <uuid/uuid.h>
#include <string>
#include <stdlib.h>
#include <list>
#include <iostream>
#include <fstream>
#include <iterator> 
#include <map> 

using namespace std;

bool countSpecific(string c, int a) {
    map<char, int> counts; 
    for(int i = 0; i<c.length(); i++) {
        auto it = counts.find(c.at(i));
        if(it != counts.end()) {
            it->second += 1;
        } else {
            counts.insert(pair<char,int>(c.at(i), 1));
        }
    }

    map<char, int>::iterator it;
    for(it = counts.begin(); it != counts.end(); it++) {
        if(it->second == a) {
            return true;
        }
    }
    return false;
}

int main(int ac, char *av[])
{
    string input;

    ifstream i("input.txt");

    int twoStr = 0;
    int threeStr = 0;
    while (getline(i, input))
    {
        if(countSpecific(input, 2)) {
            twoStr++;
        }
        if(countSpecific(input, 3)) {
            threeStr++;
        }
    }
    cout << (twoStr*threeStr);
}
