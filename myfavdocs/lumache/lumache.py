import numpy as np


def np_get_random_ingredients(
    n: int = 3,
    country: str = "italy",
) -> np.ndarray:
    """
    Return a list of random ingredients as a :class:`numpy.ndarray`.

    Parameters
    ----------
    n : int
        Number of ingredients to return.
    country : str
        Home country of food.

    Returns
    -------
    numpy.ndarray

    Examples
    --------
    >>> import lumache
    >>> lumache.np_get_random_ingredients()
    array(['shells', 'gorgonzola', 'parsley'], dtype='<U10')
    """
    return np.array(["shells", "gorgonzola", "parsley"])


def pd_get_random_ingredients(
    n: int = 3,
    country: str = "italy",
) -> np.ndarray:
    """
    Return a list of random ingredients as a :class:`pandas.DataFrame`.

    Parameters
    ----------
    n : int
        Number of ingredients to return.
    country : str
        Home country of food.

    Returns
    -------
    pandas.DataFrame

    Examples
    --------
    >>> import lumache
    >>> lumache.pd_get_random_ingredients()
                0
    0      shells
    1  gorgonzola
    2     parsley
    """
    return pd.DataFrame(np.array(["shells", "gorgonzola", "parsley"]))
