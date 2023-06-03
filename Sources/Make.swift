import ArgumentParser

struct Make: ParsableCommand {
    @Option(name: .shortAndLong, help: "Path to the source yaml file")
    var from: String = "Assets/config.yaml"

    @Option(name: .shortAndLong, help: "Path to the destination environment configuration file")
    var to: String = "Assets/.env"

    func run() throws {
        print("Converting config from \(from) to \(to)")
    }
}
