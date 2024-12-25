"Create sh_library targets for .bash and .sh files"
# TODO(alex): also create sh_test and sh_binary targets

def declare_targets(ctx):
    if not ctx.sources:
        return

    ctx.targets.add(
        kind = "sh_library",
        name = "shell",
        attrs = {
            "srcs": [s.path for s in ctx.sources],
        },
    )

aspect.register_configure_extension(
    id = "silo_sh_library",
    prepare = lambda cfg: aspect.PrepareResult(
        sources = [
            aspect.SourceExtensions(".bash", ".sh"),
        ],
    ),
    declare = declare_targets,
)
