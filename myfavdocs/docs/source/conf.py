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
