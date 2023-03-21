load("@present_deps//:present_deps.bzl", "PRESENT_DEPS")

def _is_present(module_name):
    return module_name in PRESENT_DEPS

def _label_or_none(label_str):
    if not label_str or not label_str.startswith("@") or not "//" in label_str:
        fail("label_str must be an absolute label, but was {}".format(label_str))

    repo_part, relative_label = label_str.split("//")
    module_name = repo_part[len("@"):]
    if module_name in PRESENT_DEPS:
        return Label("@@{}//{}".format(PRESENT_DEPS[module_name], relative_label))
    else:
        return None

optional_dep = struct(
    is_present = _is_present,
    label_or_none = _label_or_none,
)