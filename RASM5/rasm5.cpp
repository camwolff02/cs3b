#include <iostream>
#include <fstream>
#include <string>

extern int bubbleSortCpp( int [], int);
extern "C" int bubbleSortA( int *, int);

bool loadFile(std::string filename, int arr[], int length) {
    std::ifstream file {filename};
    if (file.is_open()) {
        
        for (int i = 0; i < length; ++i) 
            file >> arr[i];
    
        file.close();
        return true;
    }
    else {
        return false;
    }
}

bool saveFile(std::string filename, int arr[], int length) {
    std::ofstream file {filename};
    if (file.is_open()) {

        for (int i = 0; i < length; ++i) 
            file << arr[i] << '\n';
        
        file.close();
        return true;
    }
    else {
        return false;
    }
}

int main() {
    int count = 200000, secsA = 0, secsCpp = 0, input;
    
    std::string filename = "input.txt";
    std::string cppOutput = "cpp_output.txt";
    std::string asmOutput = "a_output.txt";

    int length = 500;
    int cppArr[length];
    int asmArr[length];

    while (true) {
        std::cout << "               RASM5 C++ vs Assembly\n" <<
                    "              File Element Count: " << count << "\n" <<
                    "------------------------------------------------\n" <<
                    "C        Bubblesort Time: " << secsCpp << " secs\n" <<
                    "Assembly Bubblesort Time: " << secsA << " secs\n" <<
                    "------------------------------------------------\n" <<
                    "<1> Load input file (integers)\n" <<
                    "<2> Sort using C++ Bubblesort algorithm\n" <<
                    "<3> Sort using Assembly Bubblesort algorithm\n" <<
                    "<4> Quit\n\n\n" <<
                    "input: ";

        std::cin >> input;

        switch (input) {
            case 1:
                if (loadFile(filename, cppArr, length)
                and loadFile(filename, cppArr, length))
                    std::cout << "file " << filename << " read successfully\n\n\n";
                else   {
                    std::cout << "error, file read incorrectly\n";
                    return 1;
                }
                break;
            case 2:
                //bubbleSortCpp(cppArr, length);

                if (saveFile(cppOutput, cppArr, length))
                    std::cout << "c++ array sorted and saved to " << filename << "\n\n\n";
                else {
                    std::cout << "error, file not saved correctly\n";
                    return 1;
                }
                break;
            case 3:
                bubbleSortA(asmArr, length);

                if (saveFile(asmOutput, cppArr, length))
                    std::cout << "assembly array sorted and saved to " << filename << "\n\n\n";
                else {
                    std::cout << "error, file not saved correctly\n";
                    return 1;
                }
                break;
            default:
                return 0;
        }
    }
}