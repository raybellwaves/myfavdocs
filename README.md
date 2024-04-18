# myfavdocs
My opinionated favourite (yes that u is left in favourite intentially) docs 

The code to generate the files is `make_files.sh` and is designed to run on a Mac.

This came about when starting with https://www.sphinx-doc.org/en/master/tutorial/getting-started.html and building upon it.

What I like and why:
 - xarray (https://docs.xarray.dev/en/stable/) has my favorite docs but I may be biased. I made decisions here based in their configuration.
 - Using `sphinx.ext.napoleon` over `numpydoc` as it gives hyperlinks of types in the Parameters and Return. I also like the bullet points that it uses for Parameters.
 - Using `pydata_sphinx_theme` for the html theme.
 - In my case I left `autodoc_typehints` as the default. You can set it to `None` if you have types that get pretty long e.g. `Optional[dict[str | int, list[int | str], float]]...`