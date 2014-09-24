#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <cmath>

#include <vector>
#include <cstdio>
#include <cstdlib>
#include <iomanip>
#include <limits> // for declaration of 'numeric_limits'
#include <ios>    // for declaration of 'streamsize'

#if defined(_MSC_VER) || defined(__INTEL_COMPILER)
#pragma warning(disable : 869)
#pragma warning(disable : 981)
#endif

using namespace std;

//#define C			299792458			// light speed [m / s]
//#define C			2.99792458e+10		// light speed [cm / s] (direttamente da Propaga)
#define Q			1.602176487E-19		// electric charge [C]
#define Q_nC		1.602176487e-10		// electric charge [nC]
#define MP_KG		1.6726E-27			// proton mass [kg]
#define MP_G		1.6726231E-24		// proton mass [g]
#define MP_EV		938272013.0			// proton mass [eV / c^2]
#define ME_KG		9.10938291E-31		// electron mass [kg]
#define ME_G		9.10938291E-28		// electron mass [g]
#define ME_EV		510998.928			// electron mass [eV / c^2]
#define T			0.0					// initial time [ns]
#define MQ			1.875E-7			// macro electric charge [nC]
#define type		3					// particle type: 1 (electrons), 2 (positrons), 3 (protons)
#define element		-1					// element to which the particle belong (it's an ordinal number used in Propaga output; being not defined in ASTRA, we put it to -1)
#define absorbed	0
#define ordinal_n	0
#define initial_status			5			// flag particelle: negative (not yet started or lost), 0-1 (passive), 3 (probe), 5 (standard)
#define DA_CM_A_MICRON			1.e+4
#define FROM_TESLA_TO_GAUSS		1.0e+4
#define DA_ERG_A_MEV			6.241509744512e+5	// conversione mia come sotto descritta
#define FROM_VOLT_TO_STATVOLT	3.335640951982e-3	// 1 statvolt = 299.792458 volts.


void leggi_bene (ifstream & , const char * , char * , istringstream & );

