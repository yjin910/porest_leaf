#include "common.hpp"

/* Return "YYYY_MM_DD_HH:MM:SS" */
std::string
getCurrTime () {
    time_t timeObj = time(NULL);
	struct  tm* tm = localtime(&timeObj);
    std::string currTime, temp;
	currTime += std::to_string (tm->tm_year+1900);
    temp = std::to_string (tm->tm_mon+1);
    if (temp.length() == 1) temp = "0" + temp;
	currTime += ("_" + temp);
    temp = std::to_string (tm->tm_mday);
    if (temp.length() == 1) temp = "0" + temp;
    currTime += ("_" + temp);
	temp = std::to_string (tm->tm_hour);
    if (temp.length() == 1) temp = "0" + temp;
	currTime += ("_" + temp);
	temp = std::to_string (tm->tm_min);
	if (temp.length() == 1) temp = "0" + temp;
	currTime += (":" + temp);
	temp = std::to_string (tm->tm_sec);
    if (temp.length() == 1) temp = "0" + temp;
	currTime += (":" + temp);
    return currTime;
}