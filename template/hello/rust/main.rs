//! Prints a friendly greeting.

fn greeting(name: &str) -> String {
    format!("Hello, {name}!")
}

fn main() {
    println!("{}", greeting("world"));
}

#[cfg(test)]
mod tests {
    use super::greeting;

    #[test]
    fn greets_by_name() {
        assert_eq!(greeting("Bazel"), "Hello, Bazel!");
    }
}
