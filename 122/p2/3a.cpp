// g++ main.cpp -lpthread

#include <iostream>
#include <cstdlib>
#include <pthread.h>

using namespace std;

void *HelloWorld(void *tid) {
   long t = (long) tid;
   cout << "Hello World! Thread ID, " << t << endl;
   pthread_exit(NULL);
}

int main () {
   pthread_t threads[5];
   int rc;
   int i;
   
   for(int k = 0; k < 5; k++ ) {
      cout << "Creating thread, " << k << endl;
      int ret = pthread_create(&threads[k], NULL, HelloWorld, (void *) k);
   }
   pthread_exit(NULL);
}