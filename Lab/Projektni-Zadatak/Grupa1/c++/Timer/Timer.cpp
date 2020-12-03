#include "Timer.h"

Timer::Timer() : startPoint(std::chrono::high_resolution_clock::now()){}

void Timer::start(){
	startPoint = std::chrono::high_resolution_clock::now();
}

void Timer::stop(){
	auto endPoint = std::chrono::high_resolution_clock::now();
	auto start = std::chrono::time_point_cast<std::chrono::microseconds>(startPoint).time_since_epoch().count();
	auto end = std::chrono::time_point_cast<std::chrono::microseconds>(endPoint).time_since_epoch().count();

	auto duration = end - start;
	double ms = duration * 0.001;

	std::cout<<ms<<"ms"<<std::endl;
}
