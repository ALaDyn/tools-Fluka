cmake_minimum_required (VERSION 2.8.7)
project(ALaDyn)
enable_language(Fortran)
enable_language(CXX)
set(CMAKE_CXX_STANDARD 11)

# make sure that the default is a RELEASE
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RELEASE)
endif()

add_executable (mgdraw_converter 
	src/mgdraw_case3_binary_converter.f
)

add_executable (fluka_reader 
	src/fluka_reader.h
	src/fluka_reader.cpp
)

add_executable (usrbdx_binning 
	src/usrbdx_binning.cpp
)

install (
	TARGETS 
	mgdraw_converter
	fluka_reader
	usrbdx_binning
	DESTINATION ${CMAKE_SOURCE_DIR}/bin/
)

