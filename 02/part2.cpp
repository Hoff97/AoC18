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
#include <vector>

using namespace std;

int countDiff(string a, string b) {
    int c = 0;
    for(int i = 0; i<a.length(); i++) {
        if(a.at(i) != b.at(i)) {
            c++;
        }
    }
    return c;
}

int main(int ac, char *av[])
{
    string input;

    ifstream inputFile("input.txt");

    vector<string> lns;
    string line;
    for(int i = 0; i < 250; ++i) {
        inputFile >> line; lns.push_back(line);
    }

    for (int i = 0; i < 250; i++) {
        for (int j = i+1; j < 250; j++) {
            if(countDiff(lns.at(i), lns.at(j)) == 1) {
                cout << lns.at(i) << "\n";
                cout << lns.at(j) << "\n";
            }
        }
    }
}
