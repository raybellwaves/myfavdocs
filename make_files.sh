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

    .. todo::
        Fix this

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
mkdir -p docs/source/_ext

# Create docs/source/_ext/helloworld.py
cat <<'EOF' >docs/source/_ext/helloworld.py
from docutils import nodes
from docutils.parsers.rst import Directive

from sphinx.application import Sphinx
from sphinx.util.typing import ExtensionMetadata


class HelloWorld(Directive):
    def run(self):
        paragraph_node = nodes.paragraph(text='Hello World!')
        return [paragraph_node]


def setup(app: Sphinx) -> ExtensionMetadata:
    app.add_directive('helloworld', HelloWorld)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
EOF

# Create docs/source/_ext/todo.py
cat <<'EOF' >docs/source/_ext/todo.py
from docutils import nodes
from docutils.parsers.rst import Directive

from sphinx.application import Sphinx
from sphinx.locale import _
from sphinx.util.docutils import SphinxDirective
from sphinx.util.typing import ExtensionMetadata


class todo(nodes.Admonition, nodes.Element):
    pass


class todolist(nodes.General, nodes.Element):
    pass


def visit_todo_node(self, node):
    self.visit_admonition(node)


def depart_todo_node(self, node):
    self.depart_admonition(node)


class TodolistDirective(Directive):
    def run(self):
        return [todolist("")]


class TodoDirective(SphinxDirective):
    # this enables content in the directive
    has_content = True

    def run(self):
        targetid = "todo-%d" % self.env.new_serialno("todo")
        targetnode = nodes.target("", "", ids=[targetid])

        todo_node = todo("\n".join(self.content))
        todo_node += nodes.title(_("Todo"), _("Todo"))
        self.state.nested_parse(self.content, self.content_offset, todo_node)

        if not hasattr(self.env, "todo_all_todos"):
            self.env.todo_all_todos = []

        self.env.todo_all_todos.append(
            {
                "docname": self.env.docname,
                "lineno": self.lineno,
                "todo": todo_node.deepcopy(),
                "target": targetnode,
            }
        )

        return [targetnode, todo_node]


def purge_todos(app, env, docname):
    if not hasattr(env, "todo_all_todos"):
        return

    env.todo_all_todos = [
        todo for todo in env.todo_all_todos if todo["docname"] != docname
    ]


def merge_todos(app, env, docnames, other):
    if not hasattr(env, "todo_all_todos"):
        env.todo_all_todos = []
    if hasattr(other, "todo_all_todos"):
        env.todo_all_todos.extend(other.todo_all_todos)


def process_todo_nodes(app, doctree, fromdocname):
    if not app.config.todo_include_todos:
        for node in doctree.findall(todo):
            node.parent.remove(node)

    # Replace all todolist nodes with a list of the collected todos.
    # Augment each todo with a backlink to the original location.
    env = app.builder.env

    if not hasattr(env, "todo_all_todos"):
        env.todo_all_todos = []

    for node in doctree.findall(todolist):
        if not app.config.todo_include_todos:
            node.replace_self([])
            continue

        content = []

        for todo_info in env.todo_all_todos:
            para = nodes.paragraph()
            filename = env.doc2path(todo_info["docname"], base=None)
            description = _(
                "(The original entry is located in %s, line %d and can be found "
            ) % (filename, todo_info["lineno"])
            para += nodes.Text(description)

            # Create a reference
            newnode = nodes.reference("", "")
            innernode = nodes.emphasis(_("here"), _("here"))
            newnode["refdocname"] = todo_info["docname"]
            newnode["refuri"] = app.builder.get_relative_uri(
                fromdocname, todo_info["docname"]
            )
            newnode["refuri"] += "#" + todo_info["target"]["refid"]
            newnode.append(innernode)
            para += newnode
            para += nodes.Text(".)")

            # Insert into the todolist
            content.extend(
                (
                    todo_info["todo"],
                    para,
                )
            )

        node.replace_self(content)


def setup(app: Sphinx) -> ExtensionMetadata:
    app.add_config_value("todo_include_todos", False, "html")

    app.add_node(todolist)
    app.add_node(
        todo,
        html=(visit_todo_node, depart_todo_node),
        latex=(visit_todo_node, depart_todo_node),
        text=(visit_todo_node, depart_todo_node),
    )

    app.add_directive("todo", TodoDirective)
    app.add_directive("todolist", TodolistDirective)
    app.connect("doctree-resolved", process_todo_nodes)
    app.connect("env-purge-doc", purge_todos)
    app.connect("env-merge-info", merge_todos)

    return {
        "version": "0.1",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
EOF

# Create docs/source/conf.py
cat <<'EOF' >docs/source/conf.py
import os
import pathlib
import subprocess
import sys
sys.path.insert(0, pathlib.Path(__file__).parents[2].resolve().as_posix())
sys.path.append(os.path.abspath("./_ext"))
print(f"{sys.path=}")
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
    # "numpydoc",  # opting for sphinx.ext.napoleon instead
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.githubpages",
    "sphinx.ext.intersphinx",
    "sphinx.ext.napoleon",
    "sphinx.ext.todo",    
    "helloworld",
    # "todo",
]

exclude_patterns = []
pygments_style = "sphinx"
html_theme = "pydata_sphinx_theme"
html_static_path = ["_static"]
templates_path = ["_templates"]

# autodoc_typehints = "none"  # Disable links in signature

autosummary_generate = True

todo_include_todos = True

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
   :maxdepth: 1
   :caption: Contents:

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

.. todo:: Add conda install

.. _extentions:

Extenstions
-----------

.. helloworld::

.. todolist::

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
