# Finite Element Method examples

This is meant as supplementary materials and help to aid understanding of the
algorithms presented in the book by Stephen Krenk, see the Bib-entry below.

```
@book{krenk_2009,
  place={Cambridge},
  title={Non-linear Modeling and Analysis of Solids and Structures},
  DOI={10.1017/CBO9780511812163},
  publisher={Cambridge University Press},
  author={Krenk, Steen},
  year={2009}
}
```

The general idea is to provide solutions implemented in Matlab to a selection
of the assignments in the book, specifically exercises, *1.3, 1.5, 2.5, 2.6, 6.1, 6.2, 6.3, 6.4, 8.1* and *9.1*

## Getting started
You will need Matlab installed with verion R2016a or later. In addition, you will require the [CALFEM](https://github.com/CALFEM/calfem-matlab) package which you can install for usage in Matlab. Once cloned, you will need to add the path to calfem to the Matlab path by running

  ```
  addpath([path-to-calfem, "/calfem-matlab/fem"])
  ```

You can then proceed by running any of the tests, or any of the examples individually.

## Contributing

Please read [CONTRIBUTING.md](https://github.com/mgreiff/FHL066/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

For the versions available, see the [tags on this repository](https://github.com/mgreiff/FHL066/tags).

## Authors

See the list of [contributors](https://github.com/mgreiff/FHL066/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
