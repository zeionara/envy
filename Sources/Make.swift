import Foundation

import ArgumentParser
import Yams

struct Make: ParsableCommand {
    @Option(name: .shortAndLong, help: "Path to the source yaml file")
    var from: String = "config.yml"

    @Option(name: .shortAndLong, help: "Path to the destination environment configuration file")
    var to: String = ".env"

    func run() throws {
        // let text = try String(contentsOf: Path.Assets.appendingPathComponent(from), encoding: .utf8)
        // let config = try Yams.load(yaml: text) as? [String: Any]
        // print(config as Any)
        // let config = decoder.decode(
        // print(text)

        let config = try Config(from: from)

        try config.export(to: to)

        // print(config)
        // print("Converting config from \(from) to \(to)")
    }
}
