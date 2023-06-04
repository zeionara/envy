import Foundation

import ArgumentParser
import Yams

struct Make: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Should use kebab case instead of snake case")
    var kebabCase: Bool = false

    @Option(name: .shortAndLong, help: "Path to the source yaml file")
    var from: String = "config.yml"

    @Option(name: .shortAndLong, help: "Path to the destination environment configuration file")
    var to: String = ".env"

    func run() throws {
        try Config(from: from).export(to: to, as: kebabCase ? .kebabCase : .snakeCase)
    }
}
