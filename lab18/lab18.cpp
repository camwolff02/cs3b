#include <iostream>
#include <string>

extern "C" int strlength( char *);

int main() {
    std::string s1 = "Cat in the hat.";
    char str[] = "Cat in the hat.";

    std::cout << s1 << " C++ length= " << s1.length() << std::endl;
    std::cout << str << " ASM length= " << strlength(str) << std::endl;

    return 0;
}