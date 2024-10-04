"py_image"

load("@aspect_bazel_lib//lib:transitions.bzl", "platform_transition_filegroup")
load("@aspect_rules_py//py:defs.bzl", "py_image_layer")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_load")

def py3_image(name, binary, root = None, layer_groups = {}, base = "@distroless_base"):
    binary = native.package_relative_label(binary)
    binary_path = "{}{}/{}".format(root, binary.package, binary.name)
    oci_image(
        name = name + "_image",
        base = base,
        tars = py_image_layer(
            name = name + "_layers",
            py_binary = binary,
            root = root,
            layer_groups = layer_groups,
        ),
        entrypoint = [binary_path],
    )
    platform_transition_filegroup(
        name = name,
        srcs = [name + "_image"],
        target_platform = select({
            "@platforms//cpu:arm64": "@rules_go//go/toolchain:linux_arm64",
            "@platforms//cpu:x86_64": "@rules_go//go/toolchain:linux_amd64",
        }),
    )
    oci_load(
        name = name + ".load",
        image = name,
        repo_tags = [
            native.package_name() + ":latest",
        ],
    )
