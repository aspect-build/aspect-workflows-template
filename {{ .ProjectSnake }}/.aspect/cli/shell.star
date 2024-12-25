"Create sh_* targets for .bash and .sh files"

def declare_targets(ctx):
    if not ctx.sources:
        return

    is_test = lambda f: f.path.endswith("_test.sh")
    is_executable = lambda f: len(f.query_results["shebang"]) > 0
    ctx.targets.add(
        kind = "sh_library",
        name = "shell",
        attrs = {
            "srcs": [s.path for s in ctx.sources if not is_test(s) and not is_executable(s)],
        },
    )

    for file in ctx.sources:
        if is_executable(file) or is_test(file):
            ctx.targets.add(
                kind = "sh_test" if is_test(file) else "sh_binary",
                name = path.base(file.path).rstrip(path.ext(file.path)),
                attrs = {
                    "srcs": [file.path],
                }
            )

aspect.register_configure_extension(
    id = "rules_shell",
    prepare = lambda cfg: aspect.PrepareResult(
        sources = [
            aspect.SourceExtensions(".bash", ".sh"),
        ],
        queries = {
            "shebang": aspect.RegexQuery(
                expression = "#!/.*sh",
            ),
        },
    ),
    declare = declare_targets,
)
