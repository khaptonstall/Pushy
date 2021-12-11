// Copyright © 2021 Kyle Haptonstall.

import ArgumentParser
import Foundation

public struct Pushy: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A tool for easily sending push notifications to physical devices.",
        subcommands: [Send.self]
    )

    public init() {}
}
