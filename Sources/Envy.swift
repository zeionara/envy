import ArgumentParser

@main
struct Envy: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Environment configuration generator",
        version: "0.0.1",
        subcommands: [Make.self],
        defaultSubcommand: Make.self
    )
}
