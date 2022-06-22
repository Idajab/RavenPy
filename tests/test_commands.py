import re
from textwrap import dedent

import pytest
from pymbolic import var

from ravenpy.config.commands import (
    LU,
    PL,
    SOIL,
    VEG,
    LandUseClassesCommand,
    LandUseParameterListCommand,
    LinearTransform,
    SoilClassesCommand,
    SoilParameterListCommand,
    SoilProfilesCommand,
    TiedParams,
    VegetationClassesCommand,
    VegetationParameterListCommand,
)


def test_linear_transform():
    assert LinearTransform(1, 0).to_rv() == ""
    scale = var("scale")
    lt = LinearTransform(scale, 10)
    assert (
        lt.to_rv(scale=2).strip()
        == ":LinearTransform 2.000000000000000 10.000000000000000"
    )


def test_soil_classes():
    c = SoilClassesCommand(
        soil_classes=[
            SoilClassesCommand.Record(n) for n in ["TOPSOIL", "FAST_RES", "SLOW_RES"]
        ]
    )
    assert dedent(c.to_rv()) == dedent(
        """
    :SoilClasses
        TOPSOIL
        FAST_RES
        SLOW_RES
    :EndSoilClasses
    """
    )


def test_vegetation_classes():
    c = VegetationClassesCommand(
        vegetation_classes=[VegetationClassesCommand.Record("VEG_ALL", 25, 6.0, 5.3)]
    )
    assert dedent(c.to_rv()) == dedent(
        """
    :VegetationClasses
        :Attributes     ,        MAX_HT,       MAX_LAI, MAX_LEAF_COND
        :Units          ,             m,          none,      mm_per_s
        VEG_ALL         ,          25.0,           6.0,           5.3
    :EndVegetationClasses
    """
    )


def test_land_use_classe():
    c = LandUseClassesCommand(land_use_classes=[LU("LU_ALL", 0, 1)])
    assert dedent(c.to_rv()) == dedent(
        """
    :LandUseClasses
        :Attributes     ,IMPERMEABLE_FRAC, FOREST_COVERAGE
        :Units          ,           fract,           fract
        LU_ALL          ,             0.0,             1.0
    :EndLandUseClasses
    """
    )


@pytest.mark.parametrize("x", [42.0, var("x")])
def test_soil_profiles(x):
    c = SoilProfilesCommand(
        soil_profiles=[
            SOIL("DEFAULT_P", ["TOPSOIL", "FAST_RES", "SLOW_RES"], [x, 100.0, 100.0])
        ]
    )

    pat = r"DEFAULT_P\s*,\s*3,\s*TOPSOIL,\s*(.+),\s*FAST_RES,\s*100.0,\s*SLOW_RES,\s*100.0"

    m = re.findall(pat, c.to_rv())[0]
    if x == 42:
        assert m == "42.0"
    else:
        assert m == "x"
        m = re.findall(pat, c.to_rv(x=1))[0]
        assert m == "1"


def test_soil_parameter_list():
    c = SoilParameterListCommand(
        names=["POROSITY", "FIELD_CAPACITY"],
        records=[
            PL(name="[DEFAULT]", vals=[1, 0]),
            PL(name="FAST_RES", vals=[None, None]),
        ],
    )

    assert dedent(c.to_rv()) == dedent(
        """
    :SoilParameterList
        :Parameters     ,          POROSITY,    FIELD_CAPACITY
        :Units          ,              none,              none
        [DEFAULT]       ,               1.0,               0.0
        FAST_RES        ,          _DEFAULT,          _DEFAULT
    :EndSoilParameterList
    """
    )


def test_vegetation_parameter_list():
    c = VegetationParameterListCommand(
        names=["MAX_CAPACITY", "MAX_SNOW_CAPACITY", "RAIN_ICEPT_PCT", "SNOW_ICEPT_PCT"],
        records=[PL(name="VEG_ALL", vals=[10000, 10000, 0.88, 0.88])],
    )

    assert dedent(c.to_rv()) == dedent(
        """
    :VegetationParameterList
        :Parameters     ,      MAX_CAPACITY, MAX_SNOW_CAPACITY,    RAIN_ICEPT_PCT,    SNOW_ICEPT_PCT
        :Units          ,              none,              none,              none,              none
        VEG_ALL         ,           10000.0,           10000.0,              0.88,              0.88
    :EndVegetationParameterList
    """
    )


def test_land_use_parameter_list():
    c = LandUseParameterListCommand(
        names=["MELT_FACTOR", "MIN_MELT_FACTOR"],
        records=[PL(name="[DEFAULT]", vals=[1, 2.2])],
    )
    assert dedent(c.to_rv()) == dedent(
        """
    :LandUseParameterList
        :Parameters     ,       MELT_FACTOR,   MIN_MELT_FACTOR
        :Units          ,              none,              none
        [DEFAULT]       ,               1.0,               2.2
    :EndLandUseParameterList
    """
    )

    with pytest.raises(ValueError):
        LandUseParameterListCommand(
            names=["MELT_FACTOR", "MIN_MELT_FACTOR"],
            records=[PL(name="[DEFAULT]", vals=[None, 2.2])],
        )


def test_tied_params():
    X1 = var("X1")
    X2 = var("X2")
    exprs = {"ex_1": 0.2 * X1, "ex_2": 2 * X1 + 3 * X2 + 10, "ex_3": 50 + X2}
    tp = TiedParams(exprs)

    assert dedent(tp.to_rv()) == dedent(
        """
        BeginTiedParams
          ex_1 1 X1 linear 0.2 0 free
          ex_2 2 X1 X2 linear 0 3 2 10 free
          ex_3 1 X2 linear 1 50 free
        EndTiedParams
        """
    )
