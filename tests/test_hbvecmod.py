from ravenpy.models.emulators.hbvecmod import HBVECMOD, HBVECMOD_OST

default = [
    None,
    None,
    0.21941,
    0.21941,
    0.21941,
    0,
    1,
    4,
    0.04,
    1.002140,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    0,
]

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
    [0, 100],
    [0, 5],
    [0.01, 1],
    [0.001, 1],
    [1, 3],  # X25
    [0.001, 1],
    [0, 5],
]


def test_simple():
    HBVECMOD()


def test_calib_simple():
    HBVECMOD_OST()
