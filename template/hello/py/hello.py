"""Entry point that prints a friendly greeting."""

from hello.py.greet import greeting


def main() -> None:
    print(greeting("world"))


if __name__ == "__main__":
    main()
