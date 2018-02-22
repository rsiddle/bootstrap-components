# Bootstrap Examples Collector

This project allow developers to generate all Bootstrap examples.

The current master version is for Bootstrap v4.0.0.

Clone the repository

```
git clone https://github.com/rsiddle/bootstrap-examples
```

We scrape examples from the official Bootstrap [documentation](https://getbootstrap.com/docs/4.0/getting-started/introduction/). Some of the headings need to be ignored. The Bootstrap documentation may update the IDs and Classes, so you may need to spot check them.

To scrape the latest version, type the following:

```
make scrape
```

The builder can be used to generate new files. The [Makefile](./Makefile) concatenates all the template files to create one file named `all.html.` with all Bootstrap examples. Type the following:

```
make build
```

The output HTML files are generated within the `dist` folder.

## Todo

* Tidy up examples.

## Contributing

It can be difficult to keep up with the latest Bootstrap developments.

* Pull requests welcome.
* Please use a HTML beautifier for the templates.

# License

We use the [ISC license](./LICENSE.md).


