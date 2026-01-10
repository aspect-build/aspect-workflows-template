# Scaffold for basic Aspect Workflows project

## With Aspect CLI (Preferred)

Install the Aspect CLI: https://docs.aspect.build/cli/install

Then add the `init` task with

```
aspect axl add gh:aspect-build/aspect-workflows-template
```

Finally, run `aspect init`

## Manually

Install [scaffold](https://hay-kot.github.io/scaffold/) like so:

```shell
% brew tap hay-kot/scaffold-tap
% brew install scaffold
# OR
% go install github.com/hay-kot/scaffold@latest
```

And then create a new project like so:

```shell
% scaffold new https://github.com/aspect-build/aspect-workflows-template
```
