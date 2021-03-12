#########################################################################
:FileType          rvp ASCII Raven 3.0.4
:WrittenBy         James Craig & Juliane Mai
:CreationDate      Feb 2020
#
# Emulation of SAC-SMA simulation of Salmon River near Prince George
#------------------------------------------------------------------------

# --------------------------
# Parameters and description
# (adopted from Table 1 under https://wiki.ewater.org.au/display/SD41/Sacramento+Model+-+SRG)
# --------------------------
# para_x01 0.001  0.015    # LZPK;           The ratio of water in LZFPM, which drains as base flow each day.; fraction; default=0.01
# para_x02 0.03   0.2      # LZSK;           The ratio of water in LZFSM which drains as base flow each day.; fraction; default=0.05
# para_x03 0.2    0.5      # UZK;            The fraction of water in UZFWM, which drains as interflow each day.; fraction; default=0.3
# para_x04 0.025  0.125    # UZTWM;          Upper Zone Tension Water Maximum. The maximum volume of water held by the upper zone between
#                                            field capacity and the wilting point which can be lost by direct evaporation and evapotranspiration
#                                            from soil surface. This storage is filled before any water in the upper zone is transferred to
#                                            other storages.; m; default=0.050
# para_x05 0.010  0.075    # UZFWM;          Upper Zone Free Water Maximum, this storage is the source of water for interflow and the driving
#                                            force for transferring water to deeper depths.; m; default=0.040
# para_x06 0.075  0.300    # LZTWM;          Lower Zone Tension Water Maximum, the maximum capacity of lower zone tension water. Water from
#                                            this store can only be removed through evapotranspiration.; m; default=0.130
# para_x07 0.015  0.300    # LZFSM;          Lower Zone Free Water Supplemental Maximum, the maximum volume from which supplemental base flow
#                                            can be drawn.; m; default=0.025
# para_x08 0.040  0.600    # LZFPM;          Lower Zone Free Water Primary Maximum, the maximum capacity from which primary base flow can be
#                                            drawn.; m; default=0.060
# para_x09 0.0    0.5      # PFREE;          The minimum proportion of percolation from the upper zone to the lower zone directly available
#                                            for recharging the lower zone free water stores.; percent/100; default=0.06
# para_x10 0.0    3.0      # REXP;           An exponent determining the rate of change of the percolation rate with changing lower zone water
#                                            storage.; none; default=1.0
# para_x11 0.0    80       # ZPERC;          The proportional increase in Pbase that defines the maximum percolation rate.;
#                                            none; default=40
# para_x12 0.0    0.8      # SIDE;           The ratio of non-channel baseflow (deep recharge) to channel (visible) baseflow.; ratio;
#                                            default=0.0
# n/a      0.0    0.1      # SSOUT;          The volume of the flow which can be conveyed by porous material in the bed of stream.; mm;
#                                            default=0.0
# para_x13 0.0    0.05     # PCTIM;          The permanently impervious fraction of the basin contiguous with stream channels, which
#                                            contributes to direct runoff.; percent/100; default=0.01
# para_x14 0.0    0.2      # ADIMP;          The additional fraction of the catchment which develops impervious characteristics under
#                                            soil saturation conditions.; percent/100; default=0.0
# para_x15 0.0    0.1      # RIVA=SARVA;     A decimal fraction representing that portion of the basin normally covered by streams,
#                                            lakes and vegetation that can deplete stream flow by evapotranspiration.; percent/100;
#                                            default=0.0
# para_x16 0.0    0.4      # RSERV;          Fraction of lower zone free water unavailable for transpiration; percent/100; default=0.3
# n/a      0.0    1.0      # UH1;            The first  component of the unit hydrograph, i.e. the proportion of instantaneous runoff
#                                            not lagged; percent/100; default=1.0
# n/a      0.0    1.0      # UH2;            The second component of the unit hydrograph, i.e. the proportion of instantaneous runoff
#                                            not lagged; percent/100; default=1.0
# n/a      0.0    1.0      # UH3;            The third  component of the unit hydrograph, i.e. the proportion of instantaneous runoff
#                                            not lagged; percent/100; default=1.0
# n/a      0.0    1.0      # UH4;            The fourth component of the unit hydrograph, i.e. the proportion of instantaneous runoff
#                                            not lagged; percent/100; default=1.0
# n/a      0.0    1.0      # UH5;            The fifth  component of the unit hydrograph, i.e. the proportion of instantaneous runoff
#                                            not lagged; percent/100; default=1.0
# para_x17 0.0    8.0      # MELT_FACTOR;    maximum snow melt factor used in degree day models (not in original SAC-SMA
#                                            model); mm/d/C; default=1.5
# para_x18 0.3    20.0     # GAMMA_SHAPE;    used to build unit hydrograph, LandUseParameterList; none ; default=1.0
# para_x19 0.01   5.0      # GAMMA_SCALE;    used to build unit hydrograph, LandUseParameterList; none ; default=1.0
# para_x20 0.8    1.2      # RAINCORRECTION; Muliplier to correct rain, Gauge; none ; default=1.0
# para_x21 0.8    1.2      # SNOWCORRECTION; Muliplier to correct snow, Gauge; none ; default=1.0

#

# tied parameters:
# (it is important for OSTRICH to find every parameter place holder somewhere in this file)
# (without this parameters that are used to derive parameters wouldn't be detectable by Ostrich)
#    para_x04_mm       = par_soil0_mm     = para_x04 * 1000       =  par_x04 * 1000
#    para_x06_mm       = par_soil2_mm     = para_x06 * 1000       =  par_x06 * 1000
#    para_bf_loss_frac = par_bf_loss_frac = para_x12/(1+para_x12) = par_x12/(1+par_x12)
#    para_pow__x01     = pow_x01          = 10^(para_x01)         = 10^par_x01
#    para_pow__x02     = pow_x02          = 10^(para_x02)         = 10^par_x02
#    para_pow__x03     = pow_x03          = 10^(para_x03)         = 10^par_x03


#-----------------------------------------------------------------
# Soil Classes
#-----------------------------------------------------------------
:SoilClasses
  :Attributes,
  :Units,
    UZT,
    UZF,
    LZT,
    LZFP,
    LZFS,
    ADIM,
    GW
:EndSoilClasses

#-----------------------------------------------------------------
# Land Use Classes
#-----------------------------------------------------------------
:LandUseClasses,
  :Attributes,           IMPERM,    FOREST_COV,
       :Units,             frac,          frac,
       FOREST,          par_x13,           1.0,
#      FOREST,          <PCTIM>,           1.0,
#      FOREST,         para_x13,           1.0,
#
:EndLandUseClasses



#-----------------------------------------------------------------
# Vegetation Classes
#-----------------------------------------------------------------
:VegetationClasses,
  :Attributes,        MAX_HT,       MAX_LAI, MAX_LEAF_COND,
       :Units,             m,          none,      mm_per_s,
       FOREST,             4,             5,             5,
#      FOREST,             4,             5,             5,
:EndVegetationClasses

#-----------------------------------------------------------------
# Soil Profiles
#-----------------------------------------------------------------
:SoilProfiles
       LAKE, 0
  DEFAULT_P, 7, UZT,          par_x04, UZF,          par_x05, LZT,           par_x06, LZFP,           par_x08, LZFS,          par_x07, ADIM, 100, GW, 100
# DEFAULT_P, 7, UZT,          <UZTWM>, UZF,          <UZFWM>, LZT,           <LZTWM>, LZFP,           <LZFPM>, LZFS,          <LZFSM>, ADIM, 100, GW, 100
# DEFAULT_P, 7, UZT,         para_x04, UZF,         para_x05, LZT,          para_x06, LZFP,          para_x08, LZFS,         para_x07, ADIM, 100, GW, 100
:EndSoilProfiles

#-----------------------------------------------------------------
# Global Parameters
#-----------------------------------------------------------------

#-----------------------------------------------------------------
# Soil Parameters
#-----------------------------------------------------------------
:SoilParameterList
  :Parameters,        POROSITY,   SAC_PERC_ALPHA,   SAC_PERC_EXPON,   SAC_PERC_PFREE,
       :Units,             [-],              [-],              [-],           [0..1],
    [DEFAULT],             1.0,          par_x11,          par_x10,          par_x09,
#   [DEFAULT],             1.0,          <ZPERC>,           <REXP>,          <PFREE>,
#   [DEFAULT],             1.0,         para_x11,         para_x10,         para_x09,
:EndSoilParameterList
:SoilParameterList
  :Parameters,        BASEFLOW_COEFF,     UNAVAIL_FRAC
       :Units,                   1/d,             0..1
    [DEFAULT],                   0.0,              0.0
       UZF,                  pow_x03,              0.0
       LZFP,                 pow_x01,          par_x16
       LZFS,                 pow_x02,              0.0
#   [DEFAULT],                   0.0,              0.0
#      UZF,                    <UZK>,              0.0
#      LZFP,                  <LZPK>,          <RSERV>
#      LZFS,                  <LZSK>,              0.0
#   [DEFAULT],                   0.0,              0.0
#      UZF,              10^para_x03,              0.0
#      LZFP,             10^para_x01,         para_x16
#      LZFS,             10^para_x02,              0.0
:EndSoilParameterList

#-----------------------------------------------------------------
# Land Use Parameters
#-----------------------------------------------------------------
:LandUseParameterList
  :Parameters,      GAMMA_SHAPE,      GAMMA_SCALE,      MELT_FACTOR,  STREAM_FRACTION, MAX_SAT_AREA_FRAC,      BF_LOSS_FRACTION
       :Units,                -,                -,           mm/d/C,           [0..1],            [0..1],                [0..1]
    [DEFAULT],          par_x18,          par_x19,          par_x17,          par_x15,           par_x14,      par_bf_loss_frac
#                      para_x18,         para_x19,         para_x17,           <RIVA>,           <ADIMP>,     <SIDE>/(1+<SIDE>)
#                      para_x18,         para_x19,         para_x17,         para_x15,          para_x14, para_x12/(1+para_x12)
:EndLandUseParameterList

#-----------------------------------------------------------------
# Vegetation Parameters
#-----------------------------------------------------------------
:VegetationParameterList
  :Parameters,  RAIN_ICEPT_PCT,  SNOW_ICEPT_PCT,
       :Units,               -,               -,
    [DEFAULT],             0.0,             0.0,
:EndVegetationParameterList
