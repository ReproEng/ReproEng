#include <random>
#include <iostream>
#include <array>

int main() {
    std::random_device rd;
    std::mt19937 gen(rd());

    const int len = 15;
    std::uniform_int_distribution<> distrib(0, len);
    std::array<int, len> foo;
    foo.fill(-1);
    int i = 0;
    while (i < len) {
        int rnd = distrib(gen);
        if (foo[rnd] == -1) {
            foo[rnd] = i;
            i++;
        }
    }

    for (int i = len - 1; i >= 0; i--) {
        std::cout << foo[i] << std::endl;
    }
    return 0;
}
