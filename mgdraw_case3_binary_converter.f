        program leggi_binario_fortran
*
*
* First record:
* NCASE, NPFLKA, NSTMAX, TKESUM, WEIPRI, (three integers and two real variables)
*
* Next record:
* (ILOFLK(I), ETOT(I), WTFLK(I), XFLK(I), YFLK(I), ZFLK(I), TXFLK(I), TYFLK(I),
* TZFLK(I), I = 1, NPFLKA) (NPFLKA times (that is, one integer + 8 real variables))
*
* where:
* NCASE = number of primaries treated so far (including the current one)
* NPFLKA = number of particles in the stack
* NSTMAX = maximum number of particles in stack so far
* TKESUM = total kinetic energy of the primaries of a user written SOURCE
* WEIPRI = total weight of the primaries handled so far
* ILOFLK(I) = type of the Ith stack particle (see 5.1)
* ETOT(I) = total energy of Ith stack particle
* XFLK(I), YFLK(I), ZFLK(I) = source coordinates for the Ith stack particle
* TXFLK(I), TYFLK(I), TZFLK(I) = direction cosines of the Ith stack particle
*
*
        IMPLICIT NONE
        INTEGER MASSIMO
        PARAMETER (MASSIMO = 2000000)
        INTEGER I, NCASE, NPFLKA, NSTMAX
        REAL TKESUM, WEIPRI
        INTEGER ILOFLK(MASSIMO), C 
        REAL ETOT(MASSIMO), WTFLK(MASSIMO)
        REAL XFLK(MASSIMO), YFLK(MASSIMO), ZFLK(MASSIMO)
        REAL TXFLK(MASSIMO), TYFLK(MASSIMO), TZFLK(MASSIMO)
        OPEN(unit=17,file='test001_TRK',form='UNFORMATTED',status='OLD')
        C = 0
        DO WHILE(.TRUE.)
        READ(17, END=997, ERR=990) NCASE, NPFLKA, NSTMAX, TKESUM, WEIPRI
        READ(17, END=997, ERR=990) 
     &         (  ILOFLK(C+I), ETOT(C+I), WTFLK(C+I), XFLK(C+I),
     &            YFLK(C+I), ZFLK(C+I), TXFLK(C+I), TYFLK(C+I),
     &            TZFLK(C+I) , I = 1, NPFLKA )
        C = C + NPFLKA
        END DO
        GO TO 997
  990    WRITE(*,*) 'Lettura fallita' , C
        STOP 
  997    WRITE(*,*) 'Lettura parametri iniziali completata'
        DO I=1, C
           WRITE(*,*)  ETOT(I), XFLK(I), YFLK(I), ZFLK(I),
     &     TXFLK(I), TYFLK(I), TZFLK(I)
        ENDDO
        WRITE(*,*) 'Totale elaborate: ', C
        END
