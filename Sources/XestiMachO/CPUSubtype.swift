// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public struct CPUSubtype: Equatable, Hashable, RawRepresentable {

    // MARK: Public Initializers

    public init(_ rawValue: UInt64) {
        self.rawValue = rawValue
    }

    public init?(rawValue: UInt64) {
        self.init(rawValue)
    }

    // MARK: Public Instance Properties

    public let rawValue: UInt64
}

// MARK: -

// swiftlint:disable identifier_name

public extension CPUSubtype {

    // MARK: Public Type Properties

    static let CPU_SUBTYPE_ARM_ALL = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_ALL))
    static let CPU_SUBTYPE_ARM_V4T = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V4T))
    static let CPU_SUBTYPE_ARM_V5TEJ = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V5TEJ))
    static let CPU_SUBTYPE_ARM_V6 = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V6))
    static let CPU_SUBTYPE_ARM_V6M = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V6M))
    static let CPU_SUBTYPE_ARM_V7 = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V7))
    static let CPU_SUBTYPE_ARM_V7EM = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V7EM))
    static let CPU_SUBTYPE_ARM_V7K = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V7K))
    static let CPU_SUBTYPE_ARM_V7M = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V7M))
    static let CPU_SUBTYPE_ARM_V7S = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V7S))
    static let CPU_SUBTYPE_ARM_V8 = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_V8))
    static let CPU_SUBTYPE_ARM_XSCALE = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM_XSCALE))
    static let CPU_SUBTYPE_ARM64_ALL = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM64) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM64_ALL))
    static let CPU_SUBTYPE_ARM64_E = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM64) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM64E))
    static let CPU_SUBTYPE_ARM64_V8 = CPUSubtype(UInt64(MachO.CPU_TYPE_ARM64) << 32 | UInt64(MachO.CPU_SUBTYPE_ARM64_V8))
    static let CPU_SUBTYPE_I386_ALL = CPUSubtype(UInt64(MachO.CPU_TYPE_I386) << 32 | UInt64(MachO.CPU_SUBTYPE_X86_ALL))
    static let CPU_SUBTYPE_X86_64_ALL = CPUSubtype(UInt64(MachO.CPU_TYPE_X86_64) << 32 | UInt64(MachO.CPU_SUBTYPE_X86_64_ALL))
    static let CPU_SUBTYPE_X86_64_H = CPUSubtype(UInt64(MachO.CPU_TYPE_X86_64) << 32 | UInt64(MachO.CPU_SUBTYPE_X86_64_H))
}

// swiftlint:enable identifier_name

// MARK: -

public extension CPUSubtype {

    // MARK: Public Instance Properties

    var briefDescription: String {
        guard
            let name = CPUSubtype.briefCPUSubtypeNames[self]
            else { return String(describing: rawValue) }

        return name
    }

    // MARK: Private Type Properties

    private static let briefCPUSubtypeNames: [CPUSubtype: String] = [
        .CPU_SUBTYPE_ARM_ALL: "ALL",
        .CPU_SUBTYPE_ARM_V4T: "V4T",
        .CPU_SUBTYPE_ARM_V5TEJ: "V5TEJ",
        .CPU_SUBTYPE_ARM_V6: "V6",
        .CPU_SUBTYPE_ARM_V6M: "V6M",
        .CPU_SUBTYPE_ARM_V7: "V7",
        .CPU_SUBTYPE_ARM_V7EM: "V7EM",
        .CPU_SUBTYPE_ARM_V7K: "V7K",
        .CPU_SUBTYPE_ARM_V7M: "V7M",
        .CPU_SUBTYPE_ARM_V7S: "V7S",
        .CPU_SUBTYPE_ARM_V8: "V8",
        .CPU_SUBTYPE_ARM_XSCALE: "XSCALE",
        .CPU_SUBTYPE_ARM64_ALL: "ALL",
        .CPU_SUBTYPE_ARM64_E: "E",
        .CPU_SUBTYPE_ARM64_V8: "V8",
        .CPU_SUBTYPE_I386_ALL: "ALL",
        .CPU_SUBTYPE_X86_64_ALL: "ALL",
        .CPU_SUBTYPE_X86_64_H: "H"
    ]
}

// MARK: - CustomStringConvertible

extension CPUSubtype: CustomStringConvertible {
    public var description: String {
        guard
            let name = CPUSubtype.cpuSubtypeNames[self]
            else { return "CPU_SUBTYPE_??? (\(rawValue))" }

        return name
    }

    // MARK: Private Type Properties

    private static let cpuSubtypeNames: [CPUSubtype: String] = [
        .CPU_SUBTYPE_ARM_ALL: "CPU_SUBTYPE_ARM_ALL",
        .CPU_SUBTYPE_ARM_V4T: "CPU_SUBTYPE_ARM_V4T",
        .CPU_SUBTYPE_ARM_V5TEJ: "CPU_SUBTYPE_ARM_V5TEJ",
        .CPU_SUBTYPE_ARM_V6: "CPU_SUBTYPE_ARM_V6",
        .CPU_SUBTYPE_ARM_V6M: "CPU_SUBTYPE_ARM_V6M",
        .CPU_SUBTYPE_ARM_V7: "CPU_SUBTYPE_ARM_V7",
        .CPU_SUBTYPE_ARM_V7EM: "CPU_SUBTYPE_ARM_V7EM",
        .CPU_SUBTYPE_ARM_V7K: "CPU_SUBTYPE_ARM_V7K",
        .CPU_SUBTYPE_ARM_V7M: "CPU_SUBTYPE_ARM_V7M",
        .CPU_SUBTYPE_ARM_V7S: "CPU_SUBTYPE_ARM_V7S",
        .CPU_SUBTYPE_ARM_V8: "CPU_SUBTYPE_ARM_V8",
        .CPU_SUBTYPE_ARM_XSCALE: "CPU_SUBTYPE_ARM_XSCALE",
        .CPU_SUBTYPE_ARM64_ALL: "CPU_SUBTYPE_ARM64_ALL",
        .CPU_SUBTYPE_ARM64_E: "CPU_SUBTYPE_ARM64_E",
        .CPU_SUBTYPE_ARM64_V8: "CPU_SUBTYPE_ARM64_V8",
        .CPU_SUBTYPE_I386_ALL: "CPU_SUBTYPE_I386_ALL",
        .CPU_SUBTYPE_X86_64_ALL: "CPU_SUBTYPE_X86_64_ALL",
        .CPU_SUBTYPE_X86_64_H: "CPU_SUBTYPE_X86_64_H"
    ]
}
