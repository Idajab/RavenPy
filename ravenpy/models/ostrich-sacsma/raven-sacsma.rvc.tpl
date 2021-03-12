#########################################################################
:FileType          rvc ASCII Raven 3.0.4
:WrittenBy         Juliane Mai & James Craig
:CreationDate      Feb 2021
#
# Emulation of SAC-SMA simulation of Salmon River near Prince George
#------------------------------------------------------------------------
#

# initialize to full tension storage
:UniformInitialConditions SOIL[0] par_soil0_mm #<UZTWM> = para_x04*1000
:UniformInitialConditions SOIL[2] par_soil2_mm #<LZTWM> = para_x06*1000
