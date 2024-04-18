#!/bin/zsh
# A shell script that generates files provided in the sphinx tutorial:
# https://www.sphinx-doc.org/en/master/tutorial/getting-started.html
# run as ./make_files.sh

# Create README.rst
cat <<'EOF' >README.rst
myfavdocs
=========

**Lumache** (/lu'make/) is a Python library for cooks and food lovers that
creates recipes mixing random ingredients. I've rename it to myfavdocs to
back life easier deploying to gh-pages.
EOF

# Create lumache.py
cat <<'EOF' >myfavdocs.py
import numpy as np
import pandas as pd


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
    >>> import myfavdocs
    >>> myfavdocs.np_get_random_ingredients()
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
    >>> import myfavdocs
    >>> myfavdocs.pd_get_random_ingredients()
                0
    0      shells
    1  gorgonzola
    2     parsley
    """
    return pd.DataFrame(np.array(["shells", "gorgonzola", "parsley"]))
EOF

mkdir -p docs/source
mkdir -p docs/source/_static
mkdir -p docs/source/_templates

# Create docs/source/conf.py
cat <<'EOF' >docs/source/conf.py
import os
import pathlib
import subprocess
import sys
sys.path.insert(0, pathlib.Path(__file__).parents[2].resolve().as_posix())
print("sys.path:", sys.path)
if "CONDA_DEFAULT_ENV" in os.environ or "conda" in sys.executable:
    print("conda environment:")
    subprocess.run([os.environ.get("CONDA_EXE", "conda"), "list"])
else:
    print("pip environment:")
    subprocess.run([sys.executable, "-m", "pip", "list"])
project = "myfavdocs"
copyright = "2024, Graziella"
author = "Graziella"

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.githubpages",
    "sphinx.ext.intersphinx",
    "sphinx.ext.napoleon",
]

exclude_patterns = []
pygments_style = "sphinx"
html_theme = "pydata_sphinx_theme"
html_static_path = ["_static"]

autosummary_generate = True

# autodoc_typehints = "none"  # Disable links in signature

templates_path = ["_templates"]

intersphinx_mapping = {
    "pandas": (
        "https://pandas.pydata.org/pandas-docs/stable/",
        "https://pandas.pydata.org/pandas-docs/stable/objects.inv",
    ),
    "python": (
        "https://docs.python.org/3",
        "https://docs.python.org/3/objects.inv",
    ),
    "numpy": (
        "https://numpy.org/doc/stable",
        "https://numpy.org/doc/stable/objects.inv",
    ),
}
EOF

# Create docs/source/lumache.rst and docs/source/modules.rst
#cd docs
#sphinx-apidoc -f -o source ../.
#cd ..

# Create docs/source/api.rst
cat <<'EOF' >docs/source/api.rst
.. currentmodule:: myfavdocs

.. _api:

#############
API reference
#############

Top-level functions
===================

.. autosummary::
   :toctree: generated/

   np_get_random_ingredients
   pd_get_random_ingredients
EOF

# Create the docs folder
#sphinx-quickstart docs --sep --project Lumache --author Graziella --release 0.1 --language en

# Create docs/source/index.rst
cat <<'EOF' >docs/source/index.rst
Welcome to myfavdocs's documentation!
=====================================

**Lumache** (/lu'make/) is a Python library for cooks and food lovers that
creates recipes mixing random ingredients.  It pulls data from the `Open Food
Facts database <https://world.openfoodfacts.org/>`_ and offers a *simple* and
*intuitive* API.

Check out the :doc:`usage` section for further information, including how to
:ref:`install <installation>` the project.

.. note::

   This project is under active development.

.. toctree::
   :maxdepth: 2
   :hidden:

   Usasge <usage>
   API Reference <api>
EOF

# Create docs/source/usage.rst
cat <<'EOF' >docs/source/usage.rst
Usage
=====

.. _installation:

Installation
------------

To use myfavdocs, first install it using pip:

.. code-block:: console

   (.venv) $ pip install myfavdocs
EOF

cd docs

# Create docs/Makefile
cat <<'EOF' >Makefile
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
EOF

make html
