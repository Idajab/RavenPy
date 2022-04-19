from ravenpy.extractors.routing_product import RoutingProductShapefileExtractor
from ravenpy.models import get_average_annual_runoff
from ravenpy.models.emulators.hbvecmod import HBVECMOD, HBVECMOD_OST

TS = "/home/david/src/raven-testdata/famine/famine_input.nc"
area = 100

default = [
    1.0,
    1.0,
    0.21941,
    0.15725,
    2.65,
    0.0,
    1.0,
    4.0,
    0.0464,
    1.0,
    1.0,
    1.0,
    1.0,
    0.01,
    0.01,
    1.0,
    0.03,
    0.03,
    1.1,
    0.02,
    100.0,
    0.01,
    0.01,
    0.1,
    1.0,
    0.1,
    0.01,
]

extractor = RoutingProductShapefileExtractor(
    "/home/david/src/raven-testdata/famine/hru_Famine_final.zip",
    routing_product_version="2.1",
)

bnds = [
    [1, 4],  # X1
    [1, 2],
    [0.05, 0.25],
    [0.05, 0.75],
    [0.05, 100],  # X5
    [-1, 1],
    [0, 4],
    [0, 7],
    [0.04, 0.07],
    [0, 5],  # X10
    [0.5, 2],
    [1, 7],
    [0.5, 2],
    [0.01, 1],
    [0.01, 1],  # X15
    [0.01, 10],
    [0.01, 1],
    [0.05, 0.1],
    [0.5, 2],
    [0.02, 0.2],  # X20
    [0.01, 100],
    [0, 5],
    [0.01, 1],
    [0.001, 1],
    [1, 3],  # X25
    [0.001, 1],
    [0.001, 5],
]


def test_simple():
    model = HBVECMOD(workdir="/tmp/hbvecmod")
    model.config.rvp.params = HBVECMOD.Params(*default)
    model.config.rvp.avg_annual_runoff = get_average_annual_runoff(
        TS, area * 1e6, obs_var="obs"
    )
    rv_objs = extractor.extract()
    model.config.rvp.channel_profiles = rv_objs.pop("channel_profiles")

    for k, v in rv_objs.items():
        model.config.rvh.update(k, v)

    # model.setup_model_run(ts=["/home/david/src/raven-testdata/famine/famine_input.nc"])
    model(ts=["/home/david/src/raven-testdata/famine/famine_input.nc"], overwrite=True)


def test_calib_simple():
    model = HBVECMOD_OST(workdir="/tmp/test_hbv_mod_ost")
    low, high = zip(*bnds)
    model.config.ost.lowerBounds = HBVECMOD.Params(*low)
    model.config.ost.upperBounds = HBVECMOD.Params(*high)
    model.setup_model_run(ts=[])
