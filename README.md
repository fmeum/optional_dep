# optional_dep

A Bazel module that allows cooperating Bazel modules to *optionally* depend on each other.

## Setup

Add the following snippet to the `MODULE.bazel` file of a Bazel module that should be usable as an optional dependency:

```starlark
bazel_dep(name = "optional_dep", version = "0.1.0")

optional_dep = use_extension("@optional_dep//:extensions.bzl", "optional_dep")
optional_dep.register(module_file = "//:MODULE.bazel")
```

## Usage

In any other Bazel module that wants to optionally depend on the module that has been registered above, add the following snippet to the `MODULE.bazel` file:

```starlark
bazel_dep(name = "optional_dep", version = "0.1.0")
```

Then load `optional_dep` from `@optional_dep//:defs.bzl`, which provides the following functions:

### `optional_dep.is_present(module_name: str) -> bool`

Returns `True` if the module with the given name is a transitive `bazel_dep` of the root module, `False` otherwise.

### `optional_dep.label_or_none(absolute_label: str) -> Optional[Label]`

For an absolute label of the form `@module_name//path/to/pkg:target`, returns a `Label` instance referencing this target if the module with the name `module_name` is a transitive `bazel_dep` of the root module and `None` otherwise.

## Example

See the [tests/bcr](tests/bcr) directory for an example of how to use `optional_dep`.
It contains a root module and three other modules `dep`, `optional_dep_1`, and `optional_dep_2`.
The root module depends on `dep` and `optional_dep_1`, but not on `optional_dep_2`.
The `dep` module uses `optional_dep` to optionally depend on `optional_dep_1` and `optional_dep_2`.