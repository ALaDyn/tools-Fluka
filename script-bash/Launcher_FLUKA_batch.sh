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


if [[ "${USA_SOURCE}" = "0" ]] ; then
  if [[ "${USA_PROTONI}" = "1" ]] ; then
  BEAM_TYPE_PROTON="PROTON"
  MAX_ENERGY_GEV_PROTON=0.020
  fi
  if [[ "${USA_ELETTRONI}" = "1" ]] ; then
  BEAM_TYPE_ELECTRON="ELECTRON"
  MAX_ENERGY_GEV_ELECTRON=1E-05
  fi
else
MAX_ENERGY_GEV=0.030
fi



for i in ${THICKNESS[@]}
do
##### 
if [[ "${USA_SOURCE}" = "1" ]] ; then
NUMBER_OF_PARTICLES=`wc -l < ${FLUKA_INPUT_DISTRIBUTION}.ppg`
else
NUMBER_OF_PARTICLES=10000
fi
#####
FILE_INPUT_FLUKA=test.inp
SIM_TITLE="Test with Fluka"
ZERO=0.0E0
ZER0=0
UNO=1.0
CINQUE=5
PADLENGTH=10
pad=$(printf '%0.1s' " "{1..60})
if [[ "${USA_SOURCE}" = "1" ]] ; then
BEAM_MAX_ENERGY_GEV=-${MAX_ENERGY_GEV}
else
  if [[ "${USA_PROTONI}" = "1" ]] ; then
  BEAM_MAX_ENERGY_GEV_PROTON=-${MAX_ENERGY_GEV_PROTON}
  fi
  if [[ "${USA_ELETTRONI}" = "1" ]] ; then
  BEAM_MAX_ENERGY_GEV_ELECTRON=-${MAX_ENERGY_GEV_ELECTRON}
  fi
fi
BEAMPOS_X_CM=0.0
BEAMPOS_Y_CM=0.0
BEAMPOS_Z_CM=0.0
DEFAULTS_MODE="PRECISIO"
EMFCUT_KINETIC_ELECTRONS_PROTONS_GEV=-1.0E-6
EMFCUT_PHOTONS_PRODUCTION_GEV=1.0E-6
EMFCUT_SDUM="PROD-CUT"
DELTARAY_CUT_GEV=1.0E-6
DELTARAY_SDUM="PRINT"
GEOBEGIN_SDUM="COMBNAME"
GEOMETRY_NAME="geometria test"
UNIVERSAL_SPHERE_X0_CM=0.0
UNIVERSAL_SPHERE_Y0_CM=0.0
UNIVERSAL_SPHERE_Z0_CM=0.0
UNIVERSAL_SPHERE_RADIUS_CM=10000.0
UNIVERSAL_SPHERE_MATERIAL="BLCKHOLE"
UNIVERSAL_SPHERE_NAME="BHUNIV"
UNIVERSAL_SPHERE_NAME_FREE="blkh"
SPHERICAL_SPACE_AROUND_X0_CM=0.0
SPHERICAL_SPACE_AROUND_Y0_CM=0.0
SPHERICAL_SPACE_AROUND_Z0_CM=0.0
SPHERICAL_SPACE_AROUND_RADIUS_CM=800.0
SPHERICAL_SPACE_AROUND_MATERIAL="VACUUM"
SPHERICAL_SPACE_AROUND_NAME="VACARND"
SPHERICAL_SPACE_AROUND_NAME_FREE="air"
TARGET_X0_CM=-20.0
TARGET_X1_CM=20.0
TARGET_Y0_CM=-20.0
TARGET_Y1_CM=20.0
TARGET_Z0_CM=2.0
TARGET_Z1_CM=${i}
TARGET_MATERIAL="COPPER"
TARGET_NAME="TARGET"
TARGET_NAME_FREE="target"
#STEPSIZE_MIN_CM=1.0E-10
#STEPSIZE_MAX_CM=1.1E-10
STEPSIZE_MIN_CM=5.0E-9
STEPSIZE_MAX_CM=5.5E-9
USERDUMP_ENABLE_1=200.
USERDUMP_FILE_NUMBER=44.
USERDUMP_CALL=0.0
USERDUMP_ENABLE_2=1.0
USERDUMP_FILE_NAME="TRK"
RANDOMIZER=1.0
#====================
TITLE_SCORECARD="TITLE"
BEAM_SCORECARD="BEAM"
SOURCE_SCORECARD="SOURCE"
BEAMPOS_SCORECARD="BEAMPOS"
DEFAULTS_SCORECARD="DEFAULTS"
EMFCUT_SCORECARD="EMFCUT"
DELTARAY_SCORECARD="DELTARAY"
GEOBEGIN_SCORECARD="GEOBEGIN"
GEOEND_SCORECARD="GEOEND"
SPH_SCORECARD="SPH"
RPP_SCORECARD="RPP"
ASSIGNMA_SCORECARD="ASSIGNMA"
STEPSIZE_SCORECARD="STEPSIZE"
USERDUMP_SCORECARD="USERDUMP"
RANDOMIZ_SCORECARD="RANDOMIZ"
START_SCORECARD="START"
STOP_SCORECARD="STOP"
END_SCORECARD="END"
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
#===========================
rm  ${FILE_INPUT_FLUKA}

printf '%s\n' "${TITLE_SCORECARD}" > ${FILE_INPUT_FLUKA}

printf '%s\n' "${SIM_TITLE}" >> ${FILE_INPUT_FLUKA}

if [[ "${USA_SOURCE}" = "1" ]] ; then
printf '%s' "${BEAM_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#BEAM_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s\n' "${BEAM_MAX_ENERGY_GEV}" >> ${FILE_INPUT_FLUKA}
printf '%s\n' "${SOURCE_SCORECARD}" >> ${FILE_INPUT_FLUKA}
else
if [[ "${USA_PROTONI}" = "1" ]] ; then
  printf '%s' "${BEAM_SCORECARD}" >> ${FILE_INPUT_FLUKA}
  printf '%*.*s' 0 $(( $PADLENGTH - ${#BEAM_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
  printf '%10.10s' "${BEAM_MAX_ENERGY_GEV_PROTON}" >> ${FILE_INPUT_FLUKA}
  printf '%*.*s' 0 $(( 5 * $PADLENGTH )) "$pad" >> ${FILE_INPUT_FLUKA}
  printf '%s\n' "${BEAM_TYPE_PROTON}" >> ${FILE_INPUT_FLUKA}
fi
if [[ "${USA_ELETTRONI}" = "1" ]] ; then
  printf '%s' "${BEAM_SCORECARD}" >> ${FILE_INPUT_FLUKA}
  printf '%*.*s' 0 $(( $PADLENGTH - ${#BEAM_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
  printf '%10.10s' "${BEAM_MAX_ENERGY_GEV_ELECTRON}" >> ${FILE_INPUT_FLUKA}
  printf '%*.*s' 0 $(( 5 * $PADLENGTH )) "$pad" >> ${FILE_INPUT_FLUKA}
  printf '%s\n' "${BEAM_TYPE_ELECTRON}" >> ${FILE_INPUT_FLUKA}
fi
fi


printf '%s' "${BEAMPOS_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#BEAMPOS_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s%10.10s\n' ${BEAMPOS_X_CM} ${BEAMPOS_Y_CM} ${BEAMPOS_Z_CM} >> ${FILE_INPUT_FLUKA}

printf '%s' "${DEFAULTS_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#DEFAULTS_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 6 * $PADLENGTH )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s\n' "${DEFAULTS_MODE}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${EMFCUT_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#EMFCUT_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s%10.10s%10.10s%10.10s%10.10s%s\n' "${EMFCUT_KINETIC_ELECTRONS_PROTONS_GEV}" "${EMFCUT_PHOTONS_PRODUCTION_GEV}" "$ZERO" "${SPHERICAL_SPACE_AROUND_MATERIAL}" "${TARGET_MATERIAL}" "$UNO" "${EMFCUT_SDUM}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${DELTARAY_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#DELTARAY_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s' "${DELTARAY_CUT_GEV}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 2 * $PADLENGTH )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s%10.10s%s\n' "${SPHERICAL_SPACE_AROUND_MATERIAL}" "${TARGET_MATERIAL}" "$UNO" "${DELTARAY_SDUM}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${GEOBEGIN_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#GEOBEGIN_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 6 * $PADLENGTH )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s\n' "${GEOBEGIN_SDUM}" >> ${FILE_INPUT_FLUKA}

printf '%5.5s' "${ZER0}" >> ${FILE_INPUT_FLUKA}
printf '%5.5s' "${ZER0}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 3 * $PADLENGTH - 6 - ${#GEOMETRY_NAME} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s\n' "${GEOMETRY_NAME}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${SPH_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 4 - ${#SPH_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s' "${UNIVERSAL_SPHERE_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH + 1 - ${#UNIVERSAL_SPHERE_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s %s %s %s\n' "${UNIVERSAL_SPHERE_X0_CM}" "${UNIVERSAL_SPHERE_Y0_CM}" "${UNIVERSAL_SPHERE_Z0_CM}" "${UNIVERSAL_SPHERE_RADIUS_CM}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${SPH_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 4 - ${#SPH_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s' "${SPHERICAL_SPACE_AROUND_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH + 1 - ${#SPHERICAL_SPACE_AROUND_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s %s %s %s\n' "${SPHERICAL_SPACE_AROUND_X0_CM}" "${SPHERICAL_SPACE_AROUND_Y0_CM}" "${SPHERICAL_SPACE_AROUND_Z0_CM}" "${SPHERICAL_SPACE_AROUND_RADIUS_CM}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${RPP_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 4 - ${#RPP_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s' "${TARGET_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH + 1 - ${#TARGET_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}
#printf '%s %s %s %s %s %s\n' "${TARGET_X0_CM}" "${TARGET_X1_CM}" "${TARGET_Y0_CM}" "${TARGET_Y1_CM}" "${TARGET_Z0_CM}" "${TARGET_Z1_CM}" >> ${FILE_INPUT_FLUKA}
printf '%s %s %s %s %s %s\n' "${TARGET_X0_CM}" "${TARGET_X1_CM}" "${TARGET_Y0_CM}" "${TARGET_Y1_CM}" "${TARGET_Z0_CM}" "${i}" >> ${FILE_INPUT_FLUKA}

printf '%s\n' "${END_SCORECARD}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${UNIVERSAL_SPHERE_NAME}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#UNIVERSAL_SPHERE_NAME} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%4.4s' "${CINQUE}" >> ${FILE_INPUT_FLUKA}
printf ' +' >> ${FILE_INPUT_FLUKA}
printf '%s' "${UNIVERSAL_SPHERE_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - 2 - ${#UNIVERSAL_SPHERE_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf ' -' >> ${FILE_INPUT_FLUKA}
printf '%s' "${SPHERICAL_SPACE_AROUND_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s\n' 0 $(( $PADLENGTH - 2 - ${#SPHERICAL_SPACE_AROUND_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}

printf '%s' "${SPHERICAL_SPACE_AROUND_NAME}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#SPHERICAL_SPACE_AROUND_NAME} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%4.4s' "${CINQUE}" >> ${FILE_INPUT_FLUKA}
printf ' +' >> ${FILE_INPUT_FLUKA}
printf '%s' "${SPHERICAL_SPACE_AROUND_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - 2 - ${#SPHERICAL_SPACE_AROUND_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf ' -' >> ${FILE_INPUT_FLUKA}
printf '%s' "${TARGET_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s\n' 0 $(( $PADLENGTH - 2 - ${#TARGET_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}

printf '%s' "${TARGET_NAME}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#TARGET_NAME} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%4.4s' "${CINQUE}" >> ${FILE_INPUT_FLUKA}
printf ' +' >> ${FILE_INPUT_FLUKA}
printf '%s' "${TARGET_NAME_FREE}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s\n' 0 $(( $PADLENGTH - 2 - ${#TARGET_NAME_FREE} )) "$pad" >> ${FILE_INPUT_FLUKA}

printf '%s\n' "${END_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%s\n' "${GEOEND_SCORECARD}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${ASSIGNMA_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#ASSIGNMA_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s\n' "${UNIVERSAL_SPHERE_MATERIAL}" "${UNIVERSAL_SPHERE_NAME}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${ASSIGNMA_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#ASSIGNMA_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s\n' "${SPHERICAL_SPACE_AROUND_MATERIAL}" "${SPHERICAL_SPACE_AROUND_NAME}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${ASSIGNMA_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#ASSIGNMA_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s\n' "${TARGET_MATERIAL}" "${TARGET_NAME}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${STEPSIZE_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#STEPSIZE_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s%10.10s%10.10s%10.10s%10.10s\n' "${STEPSIZE_MIN_CM}" "${STEPSIZE_MAX_CM}" "${TARGET_NAME}" "${ZERO}" "${ZERO}" "${ZERO}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${USERDUMP_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#USERDUMP_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s%10.10s%10.10s%10.10s' "${USERDUMP_ENABLE_1}" "${USERDUMP_FILE_NUMBER}" "${USERDUMP_CALL}" "${USERDUMP_ENABLE_2}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( 2 * $PADLENGTH )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%s\n' "${USERDUMP_FILE_NAME}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${RANDOMIZ_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#RANDOMIZ_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s\n' "${RANDOMIZER}" >> ${FILE_INPUT_FLUKA}

printf '%s' "${START_SCORECARD}" >> ${FILE_INPUT_FLUKA}
printf '%*.*s' 0 $(( $PADLENGTH - ${#START_SCORECARD} )) "$pad" >> ${FILE_INPUT_FLUKA}
printf '%10.10s\n' "${NUMBER_OF_PARTICLES}" >> ${FILE_INPUT_FLUKA}

printf '%s\n' "${STOP_SCORECARD}" >> ${FILE_INPUT_FLUKA}

#========================================
if [[ "${USA_SOURCE}" = "1" ]] ; then
#mv ${FLUKA_INPUT_DISTRIBUTION}.ppg ${FLUKA_INPUT_DISTRIBUTION}.backup
unlink ${FLUKA_INPUT_DISTRIBUTION}.ppg
fi
########################
#clean working directory
rm -f *~ test00* rantest00* fluka_default* *.o *_dump_after_foil* *.png *.ppg
########################
if [[ "${USA_SOURCE}" = "1" ]] ; then
#mv ${FLUKA_INPUT_DISTRIBUTION}.backup ${FLUKA_INPUT_DISTRIBUTION}.ppg
ln -s ../${FLUKA_INPUT_DISTRIBUTION}.ppg
fi
#========================================
#LAUNCH FLUKA
if [[ "${USA_SOURCE}" = "1" ]] ; then
${LAUNCHER_FLUKA} ${FLUKA_SOURCE} ${FLUKA_MGDRAW} ${FILE_INPUT_FLUKA} -N${FLUKA_START} -M${FLUKA_END}
fi
if [[ "${USA_SOURCE}" = "0" ]] ; then
${LAUNCHER_FLUKA} ${FLUKA_MGDRAW} ${FILE_INPUT_FLUKA} -N${FLUKA_START} -M${FLUKA_END}
fi
#END OF FLUKA RUN
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

