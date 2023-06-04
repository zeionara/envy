import Foundation

import ArgumentParser
import Yams

enum CommandError: Error {
    case cannotGenerateReaderForKebabCasedConfig
}

struct Make: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Should use kebab case instead of snake case")
    var kebabCase: Bool = false

    @Flag(name: .shortAndLong, help: "Generate config reader")
    var reader: Bool = false

    @Option(name: .shortAndLong, help: "Path to the source yaml file")
    var from: String = "config.yml"

    @Option(name: .shortAndLong, help: "Path to the destination environment configuration file")
    var to: String = ".env"

    func run() throws {
        if kebabCase && reader {
            throw CommandError.cannotGenerateReaderForKebabCasedConfig
        }

        let config = try Config(from: from)

        try config.export(to: to, as: kebabCase ? .kebabCase : .snakeCase)

        if reader {
            try config.exportReader(to: "\(to).reader", as: .js)
        }
    }
}
