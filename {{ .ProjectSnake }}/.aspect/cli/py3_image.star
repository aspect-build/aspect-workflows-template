"Generate py_pytest_main targets"
aspect.register_rule_kind("py3_image", {
    "From": "//tools/oci:py3_image.bzl",
    "ResolveAttrs": ["deps"],
})

def declare_targets(ctx):
    """Check for presence of pragma, generate rules if found"""
    for file in ctx.sources:
        has_pragma = len(file.query_results["pragma"]) > 0
        if has_pragma:
            ctx.targets.add(
                kind = "py3_image",
                name = "image",
                attrs = {
                },
            )
            break
aspect.register_configure_extension(
    id = "py3_image",
    prepare = lambda cfg: aspect.PrepareResult(
        sources = [
            aspect.SourceGlobs("__main__.py"),
        ],
        queries = {
            "pragma": aspect.RegexQuery(
                filter = "__main__.py",
                expression = """#\\s*oci:\\s*build""",
            ),
        },
    ),
    declare = declare_targets,
)
