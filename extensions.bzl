def _present_deps_impl(repository_ctx):
    repository_ctx.file("BUILD.bazel", "exports_files([\"present_deps.bzl\"])")
    repository_ctx.file("WORKSPACE.bazel")
    repository_ctx.file(
        "present_deps.bzl",
        "PRESENT_DEPS = " + repr(repository_ctx.attr.present_deps),
    )

_present_deps = repository_rule(
    _present_deps_impl,
    attrs = {
        "present_deps": attr.string_dict(),
    },
)

def _optional_dep_impl(module_ctx):
    labels = {}

    for module in module_ctx.modules:
        # In the case of a multiple_version_override, we want to use the version
        # that is closest to the root module in the dependency graph.
        if module.name in labels:
            continue
        if not module.tags.register:
            continue
        labels[module.name] = module.tags.register[0].module_file

    _present_deps(
        name = "present_deps",
        present_deps = {
            module_name: label.workspace_name
            for module_name, label in labels.items()
        },
    )

_register = tag_class(
    attrs = {
        "module_file": attr.label(
            mandatory = True,
        ),
    },
)

optional_dep = module_extension(
    _optional_dep_impl,
    tag_classes = {
        "register": _register,
    },
)
