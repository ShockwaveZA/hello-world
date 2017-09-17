#include <iostream>
#include <unistd.h>
#include <sys/file.h>

#include <string>
#include <fstream>
#include <thread>
#include <mutex>
#include <cstdlib>

using namespace std;

int fd;

void writeToFile(int threadNumber)
{
	ofstream f;
	f.open("filelock.txt", ofstream::app);
	for (int k = 1; k <= 10; k++)
		f << threadNumber * k << " ";
	f << "\n";
	f.close();
}

void lock()
{
	flock(fd, LOCK_EX);
}

void unlock()
{
	flock(fd, LOCK_UN);
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
	cout << "Created Thread: " << this_thread::get_id() << endl;
	try {
		threadFunction(threadNumber);
	}
	catch (...) {
		unlock();
		cout << "Handled it!!" << endl;
	}
}

int main(int argc, char const *argv[]) {
	int n = atoi(argv[1]);
	thread t[n];

	fd = open("filelock.txt", O_WRONLY);

	ofstream f;
	f.open("filelock.txt");
	f << "";
	f.close();
	
	for (int k = 0; k < n; k++) {
		t[k] = thread(caller, k + 1);
		t[k].join();
	}

	close(fd);

	return 0;
}
