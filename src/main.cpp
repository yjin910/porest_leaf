#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <unistd.h>
#include <stdio.h>
#include <time.h>

#include <stdlib.h> 
#include <errno.h> 
#include <netdb.h> 
#include <sys/types.h> 
#include <sys/stat.h> 
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <arpa/inet.h>

#include <dirent.h>
#include <errno.h>

#include "httplib.h"
#include "ml.hpp"

string OUTPUT_IMG_SAVE_PATH = "outputs/";
void upload_output(Mat, int, string);
void send_data(String, String, String, String, int);
Mat capture();
using namespace cv;
using namespace std;
using namespace httplib;

// Returns host information corresponding to host name 
void checkHostEntry(struct hostent * hostentry) 
{ 
    if (hostentry == NULL) 
    { 
        perror("gethostbyname"); 
        exit(1); 
    } 
} 

int main (int argc, char* argv[]) {
//	send_data(OUTPUT_IMG_SAVE_PATH, "2020.11.06,21:24:20.jpeg", "2020.11.06,21:24:20", "0", 1);
	int count = 0;
	for(;;){

		Mat inputImg = capture();
		OpenCV_DNN dnn;
		dnn.MachineLearning (inputImg);
		
		//file name to timestamp 	
		upload_output(dnn.getOutputImg(), dnn.getPeopleNumber(), "test_result.jpeg");
		printf("%dth capture\n", count);
		count++;
	}
    return 0;
}

Mat capture(){
	Mat frame;
	//--- INITIALIZE VIDEOCAPTURE
	VideoCapture cap;
	
	// open the camera
	cap.open(-1);
	
	// check if we succeeded
	if (!cap.isOpened()) {
		cerr << "ERROR! Unable to open camera\n";
	}

	//--- GRAB AND WRITE LOOP
	cout << "Start grabbing" << endl;
	for (;;)
	{
		// wait for a new frame from camera and store it into 'frame'
		cap.read(frame);
		// check if we succeeded
		if (frame.empty()) {
			cerr << "ERROR! blank frame grabbed\n";
			break;
		}
		// show live and wait for a key with timeout long enough to show images
		//imshow("Live", frame);
		//imwrite("dum.jpeg", frame);
		
		break;
	}
	
	return frame;
}

void upload_output (Mat resultImg, int peopleNumber, string fileName = getCurrTime()) {
	time_t t = time(0);   // get time now
	struct tm * now = localtime( & t );
	
	DIR* dir = opendir("outputs");
	if(dir){
		closedir(dir);
	}else if (ENOENT == errno) {
		mkdir("outputs/",0777);
		/* Directory does not exist. */
	}
	
	char buffer [80];
	strftime (buffer,80,"%Y.%m.%d,%H:%M:%S",now);

	string str_buffer = buffer;
	string outputPath = str_buffer + ".jpeg";

	imwrite(OUTPUT_IMG_SAVE_PATH + outputPath, resultImg);

	ofstream file;
	file.open (OUTPUT_IMG_SAVE_PATH + "results.txt", ios::out | ios::app);
	file << outputPath << " People: " << peopleNumber << "\n";
	file.close();
	
	send_data(OUTPUT_IMG_SAVE_PATH, outputPath, str_buffer, "0", peopleNumber);
}

void send_data (String filePath, String fileName, String time, String camNum, int peopleNumber){

	struct hostent *host_entry = gethostbyname("ec2-15-164-218-172.ap-northeast-2.compute.amazonaws.com"); 
	checkHostEntry(host_entry); 
	
	char *IPbuffer = inet_ntoa(*((struct in_addr*) host_entry->h_addr_list[0]));

	// IMPORTANT: 1st parameter must be a hostname or an IP adress string.
	httplib::Client cli(IPbuffer, 8090);

//	auto res = cli.Get("/porest_leaf");
//
//	if (res && res->status == 200) {
//		std::cout << res->body << std::endl;
//	}

//	httplib::Client cli("localhost", 8090);
	httplib::Params params;
	params.emplace("c", camNum);
	params.emplace("t", time);
	params.emplace("i", to_string(peopleNumber));
	params.emplace("fn", fileName);

	auto res = cli.Post("/porest_leaf", params);
	if (res && res->status == 200) {
		std::cout << res->body << std::endl;
	}
	
	std::string out;
	httplib::detail::read_file(filePath + fileName, out);
	
	httplib::MultipartFormDataItems items = {
		{"camNum", camNum, "", ""},
		{"imgFile", out, fileName, "image/jpeg"},
	};
	
	res = cli.Post("/upload/create", items);
	if (res && res->status == 200) {
		std::cout << res->body << std::endl;
	}
}
