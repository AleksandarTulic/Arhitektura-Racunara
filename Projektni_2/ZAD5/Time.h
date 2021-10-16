#include <iostream>
#include <chrono>

class Time {
private:
	std::chrono::time_point<std::chrono::high_resolution_clock> startPoint;
public:
	void start();
	double stop();
};