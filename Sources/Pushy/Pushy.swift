// Copyright © 2021 Kyle Haptonstall.

import ArgumentParser
import Foundation

struct Pushy: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A tool for easily sending push notifications to physical devices.",
        subcommands: [Send.self]
    )

    init() {}
}
