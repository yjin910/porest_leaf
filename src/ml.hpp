#ifndef ML
#define ML

#include "common.hpp"

using namespace std;
using namespace cv;
using namespace dnn;

class OpenCV_DNN {
public:

    OpenCV_DNN();

    inline Mat
    getOutputImg () { return this->outputImg.clone(); }

    inline int
    getPeopleNumber () { return this->people; }

    inline double
    getInferenceTime () { return this->t; }

    void 
    MachineLearning (Mat inputImg);

protected:

    inline void
    preprocess (Mat& frame);
    
    void
    postprocess (Mat& frame, const vector<Mat>& outs);

    void
    imagePadding (Mat& frame);

    void
    drawPred (int classId, float conf, int left, int top, int right, int bottom, Mat& frame);
    

private: // Informations for output.

    Mat outputImg;
    int people;
    double t; // inference time


private: // Variables for Machine Learning.

    string MODEL_PATH;
    string CONFIG_PATH;
    string CLASSES_PATH;
    string INPUT_IMAGE_PATH;

    Net net;

    Scalar mean;

    double scale;
    double scalarfactor;
    bool swapRB;
    int inpWidth;
    int inpHeight;

    float confThreshold;
    float nmsThreshold;

    vector<string> classes;
    vector<cv::String> outNames;
};

#endif
