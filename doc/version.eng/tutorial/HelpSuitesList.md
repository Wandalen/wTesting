# How to get a list of test suites

How to get information about test suites.

To get a list of test suites, the `.suites.list` command is used. It is used to search for test files in the specified directory. Test files have the suffix `.test`.

### Downloading

The [`Tools`](<https://github.com/Wandalen/wTools>) module has a ready test suites. Use them to test the search scenario. Clone the repository of the module by executing the `git clone https://github.com/Wandalen/wTools.git` command.

<details>
  <summary><u>File structure of <code>Tools</code> module</u></summary>

```
wTools
   ├── .git
   ├── doc
   ├── out
   ├── proto
   ├── sample
   ├── ...
   └── package.json
```

</details>

The module code, along with its tests, is located in the `proto` directory. Also, the `sample` directory can contain examples with test files.

### Run scenario

Enter the command:

```
tst .suites.list ./proto
```

The utility should scan the `proto` directory and displays a list of test suites.

<details>
  <summary><u>Command output <code>tst .suites.list ./proto</code></u></summary>

```
[user@user ~]$ tst .suites.list ./proto

/.../wTools/proto/dwtools/abase/l1.test/Array.test.s:19500 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Diagnostics.test.s:309 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Entity.test.s:808 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Map.test.s:4034 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Regexp.test.s:1749 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Routine.test.s:1558 - enabled
/.../wTools/proto/dwtools/abase/l1.test/String.test.s:3887 - enabled
/.../wTools/proto/dwtools/abase/l1.test/Typing.test.s:97 - enabled
/.../wTools/proto/dwtools/abase/l2.test/StringTools.test.s:10462 - enabled
9 test suites
```

</details>

The output shows that the `Tools` module has 9 suites tests. Each test suite is a separate file. Eight of them are in `proto/dwtools/abase/l1.test` directory and one in `proto/dwtools/abase/l2.test`.

Information about the test suite includes the path to the test file, its name, and the ability to run it.

In the `Tools` module, all test suites are enabled, so they can be run (`enabled:1` output). Test files that are disconnected from testing have the status `enabled:0`.

If you run the command `tst .suites.list ./proto/dwtools/abase/l1.test`, the utility should list the test files in this directory `./proto/dwtools/abase/l1.test`. There are eight test files in it.

### Summary

- The `.suites.list` command is used to get a list of test suites.
- The utility searches for test suites in the specified directory at all levels of nesting.
- The suites test available for testing has the status `enabled:1` and disabled - `enabled:0`.

[Back to content](../README.md#Tutorials)
