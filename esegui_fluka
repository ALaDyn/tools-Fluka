#! /bin/tcsh -f
if(  $1 == "-h" || $1 == "--help" || $1 == ""  ) then
    echo ""
    echo " LINEA COMANDO: "
    echo ""
    echo "  iniziare sempre con il file di input di fluka ( *.inp )"
    echo "  esso DEVE essere uno solo e il suo nome sara' il prefisso di tutti gli output"
    echo ""
    echo "  Quindi e' possibile procedere con le altre opzioni:"
    echo ""
    echo "     -*        -----> opzioni da trasmettere all'eseguibile di fluka"
    echo "                      sulla SUA linea comando (e.g. -NO -M5: esecuzione default)"
    echo ""
    echo "  Le opzioni che seguono sono assolutamente facoltative:"
    echo ""
    echo "  *.f *.C *.o  ---->  files sorgente (per compila_fluka e tutto_fluka)"
    echo "                      e rilocabili (per linka_fluka e tutto_fluka)"
    echo ""
    echo ""
    echo "     *         -----> il PRIMO argomento non compreso nelle precedenti categorie"
    echo "                      E' usato come nome per l'eseguibile di fluka (se ne si vuole piu' di uno"
    echo "                      nella stessa cartella: default = fluka_default)"
    echo "                      "
    echo "                      OGNI ULTERIORE ARGOMENTO e' semplicemente ignorato."
    echo "________________________________________________________________________________"
    exit
endif
#if( ! $?FLUPRO ) then
#    setenv FLUPRO /disk03/LINUXBINS/fluka64
#    setenv FLUFOR gfortran
#endif
if( ! $?FLUPRO ) then
    echo "Fluka non installato correttamente"
    exit
endif
if( ! $?FLUFOR ) then
    echo "Fluka non installato correttamente"
    exit
endif
if( `basename $0` == "compila_fluka" || `basename $0` == "tutto_fluka") then
    echo devo compilare le tue funzioni
    set i=1
    while( $i <= $#argv )
	switch( $argv[$i] )
	    case -* :
		breaksw
	    case *.inp :
		breaksw
	    default:
		echo "compilo sorgente numero $i : $argv[$i]"
		if( $argv[$i] =~ *.f ) then
		    echo sorgente fortran
		    echo ${FLUPRO}/flutil/fff -ofno-second-underscore $argv[$i]
		    ${FLUPRO}/flutil/fff -ofno-second-underscore $argv[$i]
		else if( $argv[$i] =~ *.C || $argv[$i] =~ *.cpp ) then
		    echo sorgente C++
		    echo g++ -Wall -pedantic -c $argv[$i]
		    g++ -Wall -pedantic -c $argv[$i]
		else
		    echo sorgente non valida
		endif
		breaksw
	endsw
	@ i = $i + 1
    end
endif
if( `basename $0` == "linka_fluka" || `basename $0` == "tutto_fluka" ) then
    echo devo linkare il programma eseguibile
    set RILOCABILI=( `ls -1 *.o` )
#    set RILOCABILI=""
    set i=1
    while( $i <= $#argv )
	switch( $argv[$i] )
	    case *.o:
		set RILOCABILI=( $RILOCABILI $argv[$i] )
		breaksw
	    case -*:
	    case *.f:
	    case *.C:
	    case *.cpp:
	    case *.inp:
		breaksw
	    default:
		echo candidato eseguibile $argv[$i]
		if( ! $?ESEGUIBILE ) then
		    echo candidato $argv[$i] accettato
		    set ESEGUIBILE=$argv[$i]
		endif
		breaksw
	endsw
	@ i = $i + 1
    end
if( ! $?ESEGUIBILE ) set ESEGUIBILE=fluka_default
    echo ${FLUPRO}/flutil/lfluka -o $ESEGUIBILE -m fluka $RILOCABILI
    ${FLUPRO}/flutil/lfluka -o $ESEGUIBILE -m fluka $RILOCABILI
endif
if( `basename $0` == "esegui_fluka" || `basename $0` == "tutto_fluka" ) then
    echo devo eseguire
    set OPZIONI=""
    set i=1
    while( $i <= $#argv )
	switch( $argv[$i] )
	    case -*:
		set OPZIONI=( $OPZIONI $argv[$i] )
		breaksw
	    case *.f:
	    case *.C:
	    case *.cpp
	    case *.o:
		breaksw
	    case *.inp:
		set INPUT_DATI=$argv[$i]
		breaksw
	    default:
		if( ! $?ESEGUIBILE ) set ESEGUIBILE=$argv[$i]
		breaksw
	endsw
	@ i = $i + 1
    end
    if( ! $?INPUT_DATI ) then
    echo manca file input
    exit
    endif
    set NOME=$INPUT_DATI:r
    echo "opzioni trasmesse $OPZIONI"
    echo $FLUPRO/flutil/rfluka -e $ESEGUIBILE $OPZIONI $INPUT_DATI
    $FLUPRO/flutil/rfluka -e $ESEGUIBILE $OPZIONI $INPUT_DATI
endif
