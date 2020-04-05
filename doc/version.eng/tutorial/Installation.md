# Installation

Installation of utility Testing.

### Installation of `NodeJS`

To install `Testing` you need an installed Node.js®. If you do not have it then download the version for your operating system from [official site](<https://nodejs.org/en/>) and follow the [installation instructions](https://nodejs.org/en/download/package-manager/).

### Installation of `Testing`

After you have installed NodeJS, open a operating system console and run the following command:

```
npm install -g wTesting
```

The `-g` attribute indicates a global installation of the utility.
Once installed, it's possible to run the existing test suites by the command:

```
tst .run dir
```

`Testing` will find all test suites in the `dir` directory and execute them in turn.

### Local installation

`Testing` can be installed locally.

```
npm install wTesting
```

But at the same time, executing commands of the utility will become impossible. Therefore, a group run is not possible and each test suite should be run separately.

```
node dir/TestSuite1.test.js
node dir/TestSuite2.test.js
...
```

### Summary

- `wTesting` can be installed by NPM.
- `wTesting` can be installed locally and globally.
- NodeJS is required for `wTesting`.

[Back to content](../README.md#Tutorials)
