#include <pthread.h>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <iostream>

using namespace std;

class ThreadB {
	public:
		int id;
		void* threadFunc(void) {
			cout << "Task :: threadFunc from Thread ID : " << id << endl;
		}
		
		static void* caller(void* context) {
			((ThreadB*) context)->threadFunc();
		}
		
		ThreadB(int i) {
			id = i;
		}
};

class ThreadA {
	public:
		int id;
		void* threadFunc(void) {
		    cout << "Task :: execute from Thread ID : " << id << endl;
		    
			ThreadB thread(id);
			pthread_t t;
			cout << "Waiting for thread " << id << " to execute." << endl;
			pthread_create(&t, NULL, &ThreadB::caller, &thread);
			pthread_join(t, NULL);
		}
		
		static void* caller(void* context) {
			((ThreadA*) context)->threadFunc();
		}
		
		ThreadA(int i) {
			id = i;
		}
};

int main() {
	int i = 1;
	pthread_t t;
	ThreadA thread(i);
	
	cout << "Executing thread " << i << "." << endl;
	pthread_create(&t, NULL, &ThreadA::caller, &thread);
	pthread_join(t, NULL);
	
	cout << "Exiting Main" << endl;
	return 0;
}