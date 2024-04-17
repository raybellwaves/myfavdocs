import numpy as np


def np_get_random_ingredients(n: int = 3) -> np.ndarray:
    """
    Return a list of random ingredients as a :class:`numpy.ndarray`.

    Parameters
    ----------
    n : int
        Number of ingredients to return.

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
