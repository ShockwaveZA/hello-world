// g++ main.cpp -lpthread

#include <iostream>
#include <cstdlib>
#include <pthread.h>
#include <cstring>
#include <vector>
#include <fstream>

using namespace std;

struct data {
    int id;
    string message;
};

void *ThreadMethod(void *argument) {
    struct data *args;
    args = (struct data *) argument;
    
    cout << args->message << "\t[From Thread_ID: " << args->id << "]" << endl;
    
    pthread_exit(NULL);
}

int main (int argc, char *argv[]) {
    string filename = argv[1];
    
    ifstream file(filename);
    vector<string> f;
    string line;
    
    if (file.is_open())
        while (getline(file, line))
            f.push_back(line);
    
    
   pthread_t threads[f.size()];
   struct data a[f.size()];
   
   for(int k = 0; k < f.size(); k++ ) {
      cout << "Creating Thread: " << k << endl;
      
      a[k].id = k;
      a[k].message = f[k];
      int ret = pthread_create(&threads[k], NULL, ThreadMethod, (void *) &a[k]);
      pthread_join(threads[k], NULL);
   }
   pthread_exit(NULL);
   
   return 0;
}