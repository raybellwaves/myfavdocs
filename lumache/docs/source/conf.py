import pathlib
import sys
sys.path.insert(0, pathlib.Path(__file__).parents[2].resolve().as_posix())
import sphinx_autosummary_accessors
project = "Lumache"
copyright = "2024, Graziella"
author = "Graziella"

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.intersphinx",
    "sphinx.ext.napoleon",
    "sphinx_autosummary_accessors",
]


exclude_patterns = []
pygments_style = "sphinx"
html_theme = "pydata_sphinx_theme"
html_static_path = ["_static"]

autosummary_generate = True

# autodoc_typehints = "none"  # Disable links in signature

napoleon_google_docstring = False
napoleon_use_param = True
napoleon_use_rtype = True

numpydoc_class_members_toctree = True
numpydoc_show_class_members = False

templates_path = ["_templates", sphinx_autosummary_accessors.templates_path]

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
