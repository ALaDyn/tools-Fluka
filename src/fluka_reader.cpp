#include "fluka_reader.h"


void leggi_bene(ifstream &in, const char * da_cercare, char * buff, istringstream &is)
{
	while(1)
	{
		in.getline(buff, 1025);
		if(strstr(buff, da_cercare)) break;

		if(in.eof())
		{
			cout << "questo file è una ciofeca" << endl;
			exit(250);
		}
	}

	is.clear();
	is.str(buff);
}


int main (int argc, char *argv[])
{
	if(argc < 5)
	{
		cerr << "Si usa: ./a.out  -in FILE_IN   -out FILE_OUT" << endl;
		exit(255);
	}

	ifstream input1;
	istringstream input_file;
	ofstream output_file;

	bool fallita_lettura_file_in = true, fallita_apertura_file_out = true;

	for (int i = 1; i < argc; i++)	// * We will iterate over argv[] to get the parameters stored inside.
	{								// * Note that we're starting on 1 because we don't need to know the
									// * path of the program, which is stored in argv[0]
		if (std::string(argv[i]) == "-in")
		{
			input1.open(argv[i+1]);
			fallita_lettura_file_in = input1.fail();
			i++;							// so that we skip in the for cycle the parsing of the <nome-file-particelle>
		}
		else if (std::string(argv[i]) == "-out") 
		{
			output_file.open(argv[i+1]);
			fallita_apertura_file_out = output_file.fail();
			i++;							// so that we skip in the for cycle the parsing of the <nome-file-lattice>
		}
		else
		{
			cerr << "Invalid argument: " << argv[i] << std::endl;
			exit(254);
		}
	}


	if ((fallita_lettura_file_in || fallita_apertura_file_out)) 
	{
		cerr << "Unable to open input files" << endl;
		exit(253);
	}



	char buffer[1025];
	double weight;

	leggi_bene(input1, "total weight", buffer, input_file);

	input_file.ignore(1024, ',');
	input_file.ignore(1024, 'w');
	input_file.ignore(1024, 'f');
	input_file >> weight; // letto il numero di particelle (come double!)

//	output_file << weight << endl;



	leggi_bene(input1, "linear energy binning", buffer, input_file);
	double E_min, E_max, Delta_E;
	int nbin_E;

	input_file.ignore(1024, 'm');
	input_file >> E_min;			// letta energia minima 

	input_file.ignore(1024, 'o');
	input_file >> E_max;			// letta energia massima

	input_file.ignore(1024, ',');
	input_file >> nbin_E;			// letto numero bin energia

	input_file.ignore(1024,'(');
	input_file >> Delta_E;			// letta ampiezza bins

	/**************************************
	// RE-ENABLE IF YOU WANT TO USE THE OLD usrbdx_binning TOOL - now it's included here!
	output_file << E_min << "\t" << E_max << "\t" << nbin_E << "\t" << Delta_E << endl;
	**************************************/



	leggi_bene(input1, "linear angular binning", buffer, input_file);
	double Theta_min, Theta_max, Delta_theta;
	int nbin_A;

	input_file.ignore(1024, 'm');
	input_file >> Theta_min;		// letto angolo minimo 

	input_file.ignore(1024, 'o');
	input_file >> Theta_max;		// letto angolo massimo

	input_file.ignore(1024, ',');
	input_file >> nbin_A;			// letto numero bin angolo

	input_file.ignore(1024, '(');
	input_file >> Delta_theta;		// letta ampiezza bins angolari

	/**************************************
	// RE-ENABLE IF YOU WANT TO USE THE OLD usrbdx_binning TOOL - now it's included here!
	output_file << Theta_min << "\t" << Theta_max << "\t" << nbin_A << "\t" << Delta_theta << endl;
	**************************************/
  

	leggi_bene(input1, "follow in a matrix", buffer, input_file);

	int totale_dati = nbin_E * nbin_A;
	int numero_righe = totale_dati / 10;
	int residuo_ultima_riga = totale_dati % 10;
	double *dati = new double[totale_dati];

	// saltiamo tutte le righe vuote
	do
		input1.getline(buffer, 1025);
	while(!strlen(buffer));


	for (int i = 0; i < numero_righe; i++)
	{
		input_file.clear();
		input_file.str(buffer);

		for(int k = 0; k < 10; k++)
		{
			input_file >> dati[i*10 + k];
		}

		input1.getline(buffer, 1025);
	}

	if (residuo_ultima_riga)
	{
		for (int j = 0; j < residuo_ultima_riga; j++)
		{
			input_file >> dati[numero_righe*10 + j];
		}
	}

	/**************************************
	// RE-ENABLE IF YOU WANT TO USE THE OLD usrbdx_binning TOOL - now it's included here!
	for(int k=0; k < totale_dati; k++)
	{
		cout << setprecision(4) << setiosflags(ios::scientific) << dati[k] << ' ';
		if (!((k+1) % 10)) cout << endl;
	}
	**************************************/

	double 	a_temp = E_min;

	for (int i = 0; i < nbin_A; i++)
	{
		for (int j = 0; j < nbin_E; j++)
		{
			output_file << setprecision(7) << setiosflags(ios::scientific) << a_temp << "\t" 
						<< a_temp+Delta_E << "\t" << Theta_min << "\t" << Theta_min+Delta_theta << "\t" << dati[i*nbin_E + j]*Delta_E*Delta_theta*weight << endl;
			a_temp += Delta_E;
		}
		a_temp = E_min;
		Theta_min += Delta_theta;
	}


	input1.close();
	output_file.close();
	return 0;

}
