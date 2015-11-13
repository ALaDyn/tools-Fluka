#! /bin/bash
source ~/.bashrc 

declare -a THICKNESS
#THICKNESS=( 2.0000001 2.0000002 2.0000005 2.000001 2.000002 2.000005 2.00001 2.00002 2.00005 2.0001 2.0002 2.0005 2.001 2.002 2.005 )
#THICKNESS=( 2.0000001 2.0000002 2.0000005 2.000001 2.000002 2.000005 )
#THICKNESS=( 2.00001 2.00002 2.00005 2.0001 2.0002 2.0005 2.001 2.002 2.005 )
#THICKNESS=( 2.005 )
THICKNESS=( 2.00005 )

USA_SOURCE="1"
USA_PROTONI="0"
USA_ELETTRONI="0"

#cartella nella quale copiare i risultati della simulazione
FINAL_PATH=/scratchone/stefano/GSI_BUNCH_DENEUTRALIZATION/simulations


#non esplicitare il .ppg nel nome del file che segue per come e` impostato ora lo script 
#(nelle sue funzioni di pulizia iniziale della cartella), questo file deve essere
#messo una cartella sopra quella nella quale e` questo scritp 
FLUKA_INPUT_DISTRIBUTION=distr

if [[ "${USA_SOURCE}" = "1" ]] ; then
  if [[ ! -f ../${FLUKA_INPUT_DISTRIBUTION}.ppg || ! -f ./converter || ! -f ./tutto_fluka ]]
   then
   printf "Missing Fluka launcher, distribution file or converter\n"
   exit
  fi
fi

if [[ "${USA_SOURCE}" = "0" ]] ; then
  if [[ ! -f ./converter || ! -f ./tutto_fluka ]]
   then
   printf "Missing Fluka launcher or converter\n"
   exit
  fi
fi


for i in ${THICKNESS[@]}
do
#====================
#Parameters to run the simulation
LAUNCHER_FLUKA=./tutto_fluka
FLUKA_SOURCE=source.f
FLUKA_MGDRAW=mgdraw.f
RUN_NAME=source
FLUKA_START=0
FLUKA_END=1
#====================
FLUKA_READER=./fluka_reader
CONVERTER=./converter
UNO=1
MODE_AUTO=1
C_VALUE=29979245800
MODE_CONVERT_FROM_FLUKA=29
MODE_SPLIT_P_AND_E=30
MODE_CALCULATE_ANGLE_AND_ENERGY=41
MODE_BIN_1D=40
MODE_BIN_2D=39
CONVERTER_MIN_ENERGY_E=0.001
CONVERTER_MAX_ENERGY_E=0.100
CONVERTER_MIN_ENERGY_P=0
CONVERTER_MAX_ENERGY_P=30
CONVERTER_MIN_ANGLE_E=0
CONVERTER_MAX_ANGLE_E=1571
CONVERTER_MIN_ANGLE_P=0
CONVERTER_MAX_ANGLE_P=250
N_BINS=100
CONVERTER_PROTON_ID=1
CONVERTER_ELECTRON_ID=3
#######
CONVERTER_PARTICLE_ID=7
CONVERTER_PARTICLE_WEIGHT=8
CONVERTER_PARTICLE_PX=4
CONVERTER_PARTICLE_PY=5
CONVERTER_PARTICLE_PZ=6
CONVERTER_AE_PARTICLE_ID=1
CONVERTER_AE_WEIGHT=2
CONVERTER_AE_ANGLE_COLUMN=3
CONVERTER_AE_ENERGY_COLUMN=7
#######
DUMP_PARTICLES=44
#========================================
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_CONVERT_FROM_FLUKA} test001_fort.${DUMP_PARTICLES} ${UNO}
mv conv.test001_fort.${DUMP_PARTICLES} ${RUN_NAME}_dump_after_foil.ppg
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_SPLIT_P_AND_E} ${RUN_NAME}_dump_after_foil.ppg
mv conv.${RUN_NAME}_dump_after_foil.ppg ${RUN_NAME}_dump_after_foil_p.ppg
mv conv2.${RUN_NAME}_dump_after_foil.ppg ${RUN_NAME}_dump_after_foil_e.ppg
###
if [[ "${USA_SOURCE}" = "1" ]] ; then
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_SPLIT_P_AND_E} ${FLUKA_INPUT_DISTRIBUTION}.ppg
mv conv.${FLUKA_INPUT_DISTRIBUTION}.ppg ${FLUKA_INPUT_DISTRIBUTION}_p.ppg
mv conv2.${FLUKA_INPUT_DISTRIBUTION}.ppg ${FLUKA_INPUT_DISTRIBUTION}_e.ppg
fi
###
if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
echo "${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_CALCULATE_ANGLE_AND_ENERGY} ${RUN_NAME}_dump_after_foil_p.ppg ${CONVERTER_PARTICLE_PX} ${CONVERTER_PARTICLE_PY} ${CONVERTER_PARTICLE_PZ} ${CONVERTER_PARTICLE_ID} ${CONVERTER_PARTICLE_WEIGHT}"
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_CALCULATE_ANGLE_AND_ENERGY} ${RUN_NAME}_dump_after_foil_p.ppg ${CONVERTER_PARTICLE_PX} ${CONVERTER_PARTICLE_PY} ${CONVERTER_PARTICLE_PZ} ${CONVERTER_PARTICLE_ID} ${CONVERTER_PARTICLE_WEIGHT}
mv conv.${RUN_NAME}_dump_after_foil_p.ppg ${RUN_NAME}_dump_after_foil_p.ENAN.ppg
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${RUN_NAME}_dump_after_foil_p.ENAN.ppg ${CONVERTER_AE_ENERGY_COLUMN} ${N_BINS} ${CONVERTER_MIN_ENERGY_P} ${CONVERTER_MAX_ENERGY_P} ${CONVERTER_AE_WEIGHT}
mv conv.${RUN_NAME}_dump_after_foil_p.ENAN.ppg fine_p.ENERGY.binned.ppg
fi
#the following if is removed because protons are able to generate electrons, so we always have to do what follows
#if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "1" ) ]] ; then
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_CALCULATE_ANGLE_AND_ENERGY} ${RUN_NAME}_dump_after_foil_e.ppg  ${CONVERTER_PARTICLE_PX} ${CONVERTER_PARTICLE_PY} ${CONVERTER_PARTICLE_PZ} ${CONVERTER_PARTICLE_ID} ${CONVERTER_PARTICLE_WEIGHT}
mv conv.${RUN_NAME}_dump_after_foil_e.ppg ${RUN_NAME}_dump_after_foil_e.ENAN.ppg
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${RUN_NAME}_dump_after_foil_e.ENAN.ppg ${CONVERTER_AE_ENERGY_COLUMN} ${N_BINS} ${CONVERTER_MIN_ENERGY_E} ${CONVERTER_MAX_ENERGY_E} ${CONVERTER_AE_WEIGHT}
mv conv.${RUN_NAME}_dump_after_foil_e.ENAN.ppg fine_e.ENERGY.binned.ppg
#fi
###
if [[ "${USA_SOURCE}" = "1" ]] ; then
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_CALCULATE_ANGLE_AND_ENERGY} ${FLUKA_INPUT_DISTRIBUTION}_p.ppg ${CONVERTER_PARTICLE_PX} ${CONVERTER_PARTICLE_PY} ${CONVERTER_PARTICLE_PZ} ${CONVERTER_PARTICLE_ID} ${CONVERTER_PARTICLE_WEIGHT}
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_CALCULATE_ANGLE_AND_ENERGY} ${FLUKA_INPUT_DISTRIBUTION}_e.ppg ${CONVERTER_PARTICLE_PX} ${CONVERTER_PARTICLE_PY} ${CONVERTER_PARTICLE_PZ} ${CONVERTER_PARTICLE_ID} ${CONVERTER_PARTICLE_WEIGHT}
mv conv.${FLUKA_INPUT_DISTRIBUTION}_p.ppg ${FLUKA_INPUT_DISTRIBUTION}_p.ENAN.ppg
mv conv.${FLUKA_INPUT_DISTRIBUTION}_e.ppg ${FLUKA_INPUT_DISTRIBUTION}_e.ENAN.ppg
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${FLUKA_INPUT_DISTRIBUTION}_p.ENAN.ppg ${CONVERTER_AE_ENERGY_COLUMN} ${N_BINS} ${CONVERTER_MIN_ENERGY_P} ${CONVERTER_MAX_ENERGY_P} ${CONVERTER_AE_WEIGHT}
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${FLUKA_INPUT_DISTRIBUTION}_e.ENAN.ppg ${CONVERTER_AE_ENERGY_COLUMN} ${N_BINS} ${CONVERTER_MIN_ENERGY_E} ${CONVERTER_MAX_ENERGY_E} ${CONVERTER_AE_WEIGHT}
mv conv.${FLUKA_INPUT_DISTRIBUTION}_p.ENAN.ppg inizio_p.ENERGY.binned.ppg
mv conv.${FLUKA_INPUT_DISTRIBUTION}_e.ENAN.ppg inizio_e.ENERGY.binned.ppg
fi
###
if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${RUN_NAME}_dump_after_foil_p.ENAN.ppg ${CONVERTER_AE_ANGLE_COLUMN} ${N_BINS} ${CONVERTER_MIN_ANGLE_P} ${CONVERTER_MAX_ANGLE_P} ${CONVERTER_AE_WEIGHT}
mv conv.${RUN_NAME}_dump_after_foil_p.ENAN.ppg fine_p.ANGLE.binned.ppg
fi
#if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "1" ) ]] ; then
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${RUN_NAME}_dump_after_foil_e.ENAN.ppg ${CONVERTER_AE_ANGLE_COLUMN} ${N_BINS} ${CONVERTER_MIN_ANGLE_E} ${CONVERTER_MAX_ANGLE_E} ${CONVERTER_AE_WEIGHT}
mv conv.${RUN_NAME}_dump_after_foil_e.ENAN.ppg fine_e.ANGLE.binned.ppg
#fi
###
if [[ "${USA_SOURCE}" = "1" ]] ; then
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${FLUKA_INPUT_DISTRIBUTION}_p.ENAN.ppg ${CONVERTER_AE_ANGLE_COLUMN} ${N_BINS} ${CONVERTER_MIN_ANGLE_P} ${CONVERTER_MAX_ANGLE_P} ${CONVERTER_AE_WEIGHT}
mv conv.${FLUKA_INPUT_DISTRIBUTION}_p.ENAN.ppg inizio_p.ANGLE.binned.ppg
${CONVERTER} ${MODE_AUTO} ${C_VALUE} ${MODE_BIN_1D} ${FLUKA_INPUT_DISTRIBUTION}_e.ENAN.ppg ${CONVERTER_AE_ANGLE_COLUMN} ${N_BINS} ${CONVERTER_MIN_ANGLE_E} ${CONVERTER_MAX_ANGLE_E} ${CONVERTER_AE_WEIGHT}
mv conv.${FLUKA_INPUT_DISTRIBUTION}_e.ENAN.ppg inizio_e.ANGLE.binned.ppg
fi
###
if [[ "${USA_SOURCE}" = "1" ]] ; then
gnuplot spettroAngoloElettroniInizio.plt
gnuplot spettroAngoloProtoniInizio.plt
gnuplot spettroEnergiaElettroniInizio.plt
gnuplot spettroEnergiaProtoniInizio.plt
fi
#
#if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "1" ) ]] ; then
gnuplot spettroAngoloElettroniFine.plt
gnuplot spettroEnergiaElettroniFine.plt
#fi
if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
gnuplot spettroAngoloProtoniFine.plt
gnuplot spettroEnergiaProtoniFine.plt
fi


if [[ "${USA_SOURCE}" = "1" ]] ; then
cp elec_en_inizio.png ${FINAL_PATH}/${i}_${RUN_NAME}_elec_en_inizio.png
cp prot_en_inizio.png ${FINAL_PATH}/${i}_${RUN_NAME}_prot_en_inizio.png
cp elec_an_inizio.png ${FINAL_PATH}/${i}_${RUN_NAME}_elec_an_inizio.png
cp prot_an_inizio.png ${FINAL_PATH}/${i}_${RUN_NAME}_prot_an_inizio.png
fi
if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "1" ) ]] ; then
cp elec_en_fine.png ${FINAL_PATH}/${i}_${RUN_NAME}_elec_en_fine.png
cp elec_an_fine.png ${FINAL_PATH}/${i}_${RUN_NAME}_elec_an_fine.png
fi
if [[ ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
cp elec_en_fine.png ${FINAL_PATH}/${i}_${RUN_NAME}_secondary_elec_en_fine.png
cp elec_an_fine.png ${FINAL_PATH}/${i}_${RUN_NAME}_secondary_elec_an_fine.png
fi
if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
cp prot_en_fine.png ${FINAL_PATH}/${i}_${RUN_NAME}_prot_en_fine.png
cp prot_an_fine.png ${FINAL_PATH}/${i}_${RUN_NAME}_prot_an_fine.png
fi

###### COPIA SORGENTI PER GRAFICI

if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
cp fine_p.ENERGY.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_prot_en_fine.ppg
cp fine_p.ANGLE.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_prot_an_fine.ppg
fi
if [[ "${USA_SOURCE}" = "1" || ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "1" ) ]] ; then
cp fine_e.ENERGY.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_elec_en_fine.ppg
cp fine_e.ANGLE.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_elec_an_fine.ppg
fi
if [[ ( "${USA_SOURCE}" = "0" && "${USA_ELETTRONI}" = "0" && "${USA_PROTONI}" = "1" ) ]] ; then
cp fine_e.ENERGY.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_secondary_elec_en_fine.ppg
cp fine_e.ANGLE.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_secondary_elec_an_fine.ppg
fi
if [[ "${USA_SOURCE}" = "1" ]] ; then
cp inizio_p.ENERGY.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_prot_en_inizio.ppg
cp inizio_e.ENERGY.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_elec_en_inizio.ppg
cp inizio_p.ANGLE.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_prot_an_inizio.ppg
cp inizio_e.ANGLE.binned.ppg ${FINAL_PATH}/${i}_${RUN_NAME}_elec_an_inizio.ppg
fi


done

