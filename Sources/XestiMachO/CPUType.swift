// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public struct CPUType: Equatable, Hashable, RawRepresentable {

    // MARK: Public Initializers

    public init(_ rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public init?(rawValue: UInt32) {
        self.init(rawValue)
    }

    // MARK: Public Instance Properties

    public let rawValue: UInt32
}

// MARK: -

// swiftlint:disable identifier_name

public extension CPUType {

    // MARK: Public Type Properties

    static let CPU_TYPE_ARM = CPUType(UInt32(MachO.CPU_TYPE_ARM))
    static let CPU_TYPE_ARM64 = CPUType(UInt32(MachO.CPU_TYPE_ARM64))
    static let CPU_TYPE_ARM64_32 = CPUType(UInt32(MachO.CPU_TYPE_ARM64_32))
    static let CPU_TYPE_I386 = CPUType(UInt32(MachO.CPU_TYPE_I386))
    static let CPU_TYPE_X86_64 = CPUType(UInt32(MachO.CPU_TYPE_X86_64))
}

// swiftlint:enable identifier_name

// MARK: -

public extension CPUType {

    // MARK: Public Instance Properties

    var briefDescription: String {
        guard
            let name = CPUType.briefCPUTypeNames[self]
            else { return String(describing: rawValue) }

        return name
    }

    // MARK: Private Type Properties

    private static let briefCPUTypeNames: [CPUType: String] = [
        .CPU_TYPE_ARM: "ARM",
        .CPU_TYPE_ARM64_32: "ARM64_32",
        .CPU_TYPE_ARM64: "ARM64",
        .CPU_TYPE_I386: "I386",
        .CPU_TYPE_X86_64: "X86_64"
    ]
}

// MARK: - CustomStringConvertible

extension CPUType: CustomStringConvertible {
    public var description: String {
        guard
            let name = CPUType.cpuTypeNames[self]
            else { return "CPU_TYPE_??? (\(rawValue))" }

        return name
    }

    // MARK: Private Type Properties

    private static let cpuTypeNames: [CPUType: String] = [
        .CPU_TYPE_ARM: "CPU_TYPE_ARM",
        .CPU_TYPE_ARM64_32: "CPU_TYPE_ARM64_32",
        .CPU_TYPE_ARM64: "CPU_TYPE_ARM64",
        .CPU_TYPE_I386: "CPU_TYPE_I386",
        .CPU_TYPE_X86_64: "CPU_TYPE_X86_64"
    ]
}
