#include "Time.h"

void Time::start() {
	Time::startPoint = std::chrono::high_resolution_clock::now();
}

double Time::stop() {
	auto endPoint = std::chrono::high_resolution_clock::now();
	auto start = std::chrono::time_point_cast<std::chrono::microseconds>(startPoint).time_since_epoch().count();
	auto end = std::chrono::time_point_cast<std::chrono::microseconds>(endPoint).time_since_epoch().count();

	return (end - start) * 0.000001;
}