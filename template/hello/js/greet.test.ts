import { greeting } from "./greet.js";

if (greeting("Bazel") !== "Hello, Bazel!") {
  throw new Error(`unexpected greeting: ${greeting("Bazel")}`);
}
