
#include "../../include/gerbil/Application.h"

using namespace gerbil;

int main() {

	//Application
	Application application(17,"/global/homes/q/qizhou/bella/paeruginosa30x_0001_5reads.fastq","tempDir",1,"outputTRY");
	application.process();

	return 0;
}
