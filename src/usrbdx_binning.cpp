/* Stefano Sinigardi - fluka usrbdx reader v0.1 - June2012	*/
/* GPL v3 Licensed											*/

#include <cstdio>
#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
using namespace std;


int main (int narg, char *args[], char *env[])
{
	ifstream infile;
	string nomefile;

	if(narg != 3)
	{
		cout << "si usa:  ./reader -f file_ascii_usrbdx.txt" << endl;
		cout << "si puo' redirigere l'output con > out.txt" << endl;
		return -1;
	}

	for (int i = 1; i < narg; i++)	// * We will iterate over args[] to get the parameters stored inside.
	{								// * Note that we're starting on 1 because we don't need to know the
									// * path of the program, which is stored in args[0]
		if (string(args[i]) == "-f")
		{
			nomefile = args[i+1];	// We know the next argument *should* be the <nome-file-da-analizzare>:
			i++;					// so that we skip in the for cycle the parsing of the <nome-file-particelle>
		}
		else
		{
			cerr << "Invalid argument: " << args[i] << "\n";
			return -2;
		}
	}

	double a_min, a_max, delta_a, a_temp, b_min, b_max, delta_b;
	int n_a, n_b;
	double * values;

	infile.open(nomefile.c_str());
	cerr << "Inizio lettura file " << nomefile << endl;

	infile >> a_min >> a_max >> n_a >> delta_a;
	infile >> b_min >> b_max >> n_b >> delta_b;

	cerr << "first bin: min = " << a_min << ", max = " << a_max << ", nbin = " << n_a << ", delta = " << delta_a << endl;
	cerr << "second bin: min = " << b_min << ", max = " << b_max << ", nbin = " << n_b << ", delta = " << delta_b << endl;

	a_temp = a_min;

	values = new double[(n_a+1)*(n_b+1)];

	cerr << "inizializzato vettore lettura a dimensione " << n_a+n_b << endl;
	for (int i = 1; i <= n_b; i++)
	{
		for (int j = 1; j <= n_a; j++)
		{
			infile >> values[(i-1)*n_a + j];
		}
	}

	//	for (int i = 1; i <= n_a*n_b; i++) cerr << values[i] << ' ';

	for (int i = 1; i <= n_b; i++)
	{
		for (int j = 1; j <= n_a; j++)
		{
			cout << setprecision(7) << setiosflags(ios::scientific) << a_temp << "\t" 
				<< a_temp+delta_a << "\t" << b_min << "\t" << b_min+delta_b << "\t" << values[(i-1)*n_a + j] << endl;
			a_temp += delta_a;
		}
		a_temp = a_min;
		b_min += delta_b;
	}

	cerr << "Fine lettura file " << nomefile << ". Riscritti " << n_a*n_b << " valori" << endl;
	infile.close();
	return 0;
}

