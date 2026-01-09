# iOS / Swift Bazel Starter

    # This is executable Markdown that's tested on CI.
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 `SwiftFormat`, using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting

## Try it out

> Before following these instructions, setup the developer environment by running <code>direnv allow</code> and follow any prompts.
> This ensures that tools we call in the following steps will be on the PATH.

Write a simple iOS application:

~~~sh
mkdir -p app/Sources/HelloApp

cat > app/Sources/HelloApp/HelloApp.swift <<'EOF'
import SwiftUI

@main
struct HelloApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

cat > app/Sources/HelloApp/ContentView.swift <<'EOF'
import SwiftUI
import Collections

struct ContentView: View {
    var body: some View {
        let items = OrderedSet(["Hello", "Bazel", "Swift"])
        Text(items.joined(separator: " ") + "!")
            .padding()
    }
}
EOF

cat > app/Info.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.example.helloapp</string>
    <key>CFBundleName</key>
    <string>HelloApp</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>UILaunchScreen</key>
    <dict/>
</dict>
</plist>
EOF
~~~

Declare the dependency to the package manager:

~~~sh
swift package init --type empty
cd app
swift package init --type executable
swift package add-dependency https://github.com/apple/swift-collections.git --version 1.0.0
cd ..
~~~

There isn't a Gazelle extension yet, so write a BUILD file by hand:

~~~sh
>app/BUILD cat <<EOF

EOF
~~~

Run it to see the result:
> (Note that Bundle will spam the stdout with install information, so we just want the last line)

~~~sh
output=$(bazel run //app:hello | tail -1)
~~~

Let's verify the application output matches expectation:

~~~sh
[ "${output}" = "Bazel Hello Swift!" ] || {
    echo >&2 "Wanted output 'Bazel Hello Swift!' but got '${output}'"
    exit 1
}
~~~
