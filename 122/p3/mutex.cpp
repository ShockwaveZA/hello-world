#include <iostream>
#include <unistd.h>

#include <string>
#include <fstream>
#include <thread>
#include <mutex>
#include <cstdlib>

using namespace std;

mutex m;

void writeToFile(int threadNumber)
{
	ofstream f;
	f.open("mutex.txt", ofstream::app);
	for (int k = 1; k <= 10; k++)
		f << threadNumber * k << " ";
	f << "\n";
	f.close();
}

void lock()
{
	m.lock();
}

void unlock()
{
	m.unlock();
}

void threadFunction(int threadNumber)
{
	int x = 0;
	int y = 0;
	
	try {
		lock();
		if (threadNumber % 2 == 0)
			sleep(rand() % 4 + 1);
		writeToFile(threadNumber);
		throw new exception();
		unlock();
	}
	catch (...) {
		cout << "Something went wrong!" << endl;
		throw new exception();
	}
}

void caller(int threadNumber) {
	try {
		threadFunction(threadNumber);
	}
	catch (...) {
		m.unlock();
		cout << "Handled it!!" << endl;
	}
}

int main(int argc, char const *argv[]) {
	int n = atoi(argv[1]);
	thread t[n];
	system("rm mutex.txt");
	
	for (int k = 0; k < n; k++) {
		cout << "Created Thread: " << k + 1 << endl;
		try {
			t[k] = thread(caller, k + 1);
		} catch (...) {
			m.unlock();
			cout << "Handled it!!" << endl;
		}
	}

	for (int k = 0; k < n; k++)
		t[k].join();
	
	return 0;
}
