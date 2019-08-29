// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public extension MachHeader {
    struct Flags: Hashable, OptionSet {

        // MARK: Public Initializers

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        // MARK: Public Instance Properties

        public let rawValue: UInt32
    }
}

// MARK: -

// swiftlint:disable identifier_name

public extension MachHeader.Flags {

    // MARK: Public Type Properties

    static let MH_ALLMODSBOUND = MachHeader.Flags(rawValue: UInt32(MachO.MH_ALLMODSBOUND))
    static let MH_ALLOW_STACK_EXECUTION = MachHeader.Flags(rawValue: UInt32(MachO.MH_ALLOW_STACK_EXECUTION))
    static let MH_APP_EXTENSION_SAFE = MachHeader.Flags(rawValue: UInt32(MachO.MH_APP_EXTENSION_SAFE))
    static let MH_BINDATLOAD = MachHeader.Flags(rawValue: UInt32(MachO.MH_BINDATLOAD))
    static let MH_BINDS_TO_WEAK = MachHeader.Flags(rawValue: UInt32(MachO.MH_BINDS_TO_WEAK))
    static let MH_CANONICAL = MachHeader.Flags(rawValue: UInt32(MachO.MH_CANONICAL))
    static let MH_DEAD_STRIPPABLE_DYLIB = MachHeader.Flags(rawValue: UInt32(MachO.MH_DEAD_STRIPPABLE_DYLIB))
    static let MH_DYLDLINK = MachHeader.Flags(rawValue: UInt32(MachO.MH_DYLDLINK))
    static let MH_FORCE_FLAT = MachHeader.Flags(rawValue: UInt32(MachO.MH_FORCE_FLAT))
    static let MH_HAS_TLV_DESCRIPTORS = MachHeader.Flags(rawValue: UInt32(MachO.MH_HAS_TLV_DESCRIPTORS))
    static let MH_INCRLINK = MachHeader.Flags(rawValue: UInt32(MachO.MH_INCRLINK))
    static let MH_LAZY_INIT = MachHeader.Flags(rawValue: UInt32(MachO.MH_LAZY_INIT))
    static let MH_NLIST_OUTOFSYNC_WITH_DYLDINFO = MachHeader.Flags(rawValue: UInt32(MachO.MH_NLIST_OUTOFSYNC_WITH_DYLDINFO))
    static let MH_NO_HEAP_EXECUTION = MachHeader.Flags(rawValue: UInt32(MachO.MH_NO_HEAP_EXECUTION))
    static let MH_NO_REEXPORTED_DYLIBS = MachHeader.Flags(rawValue: UInt32(MachO.MH_NO_REEXPORTED_DYLIBS))
    static let MH_NOFIXPREBINDING = MachHeader.Flags(rawValue: UInt32(MachO.MH_NOFIXPREBINDING))
    static let MH_NOMULTIDEFS = MachHeader.Flags(rawValue: UInt32(MachO.MH_NOMULTIDEFS))
    static let MH_NOUNDEFS = MachHeader.Flags(rawValue: UInt32(MachO.MH_NOUNDEFS))
    static let MH_PIE = MachHeader.Flags(rawValue: UInt32(MachO.MH_PIE))
    static let MH_PREBINDABLE = MachHeader.Flags(rawValue: UInt32(MachO.MH_PREBINDABLE))
    static let MH_PREBOUND = MachHeader.Flags(rawValue: UInt32(MachO.MH_PREBOUND))
    static let MH_ROOT_SAFE = MachHeader.Flags(rawValue: UInt32(MachO.MH_ROOT_SAFE))
    static let MH_SETUID_SAFE = MachHeader.Flags(rawValue: UInt32(MachO.MH_SETUID_SAFE))
    static let MH_SIM_SUPPORT = MachHeader.Flags(rawValue: UInt32(MachO.MH_SIM_SUPPORT))
    static let MH_SPLIT_SEGS = MachHeader.Flags(rawValue: UInt32(MachO.MH_SPLIT_SEGS))
    static let MH_SUBSECTIONS_VIA_SYMBOLS = MachHeader.Flags(rawValue: UInt32(MachO.MH_SUBSECTIONS_VIA_SYMBOLS))
    static let MH_TWOLEVEL = MachHeader.Flags(rawValue: UInt32(MachO.MH_TWOLEVEL))
    static let MH_WEAK_DEFINES = MachHeader.Flags(rawValue: UInt32(MachO.MH_WEAK_DEFINES))
}

// swiftlint:enable identifier_name

// MARK: - CustomStringConvertible

extension MachHeader.Flags: CustomStringConvertible {
    public var description: String {
        var result: [String] = []

        for bit in 0..<32 {
            let flag = MachHeader.Flags(rawValue: 1 << bit)

            if contains(flag),
                let name = MachHeader.Flags.flagNames[flag] {
                result.append(name)
            }
        }

        return result.joined(separator: " ")
    }

    // MARK: Private Type Properties

    private static let flagNames: [MachHeader.Flags: String] = [
        .MH_ALLMODSBOUND: "ALLMODSBOUND",
        .MH_ALLOW_STACK_EXECUTION: "ALLOW_STACK_EXECUTION",
        .MH_APP_EXTENSION_SAFE: "APP_EXTENSION_SAFE",
        .MH_BINDATLOAD: "BINDATLOAD",
        .MH_BINDS_TO_WEAK: "BINDS_TO_WEAK",
        .MH_CANONICAL: "CANONICAL",
        .MH_DEAD_STRIPPABLE_DYLIB: "DEAD_STRIPPABLE_DYLIB",
        .MH_DYLDLINK: "DYLDLINK",
        .MH_FORCE_FLAT: "FORCE_FLAT",
        .MH_HAS_TLV_DESCRIPTORS: "MH_HAS_TLV_DESCRIPTORS",
        .MH_INCRLINK: "INCRLINK",
        .MH_LAZY_INIT: "LAZY_INIT",
        .MH_NLIST_OUTOFSYNC_WITH_DYLDINFO: "NLIST_OUTOFSYNC_WITH_DYLDINFO",
        .MH_NO_HEAP_EXECUTION: "MH_NO_HEAP_EXECUTION",
        .MH_NO_REEXPORTED_DYLIBS: "NO_REEXPORTED_DYLIBS",
        .MH_NOFIXPREBINDING: "NOFIXPREBINDING",
        .MH_NOMULTIDEFS: "NOMULTIDEFS",
        .MH_NOUNDEFS: "NOUNDEFS",
        .MH_PIE: "PIE",
        .MH_PREBINDABLE: "PREBINDABLE",
        .MH_PREBOUND: "PREBOUND",
        .MH_SIM_SUPPORT: "SIM_SUPPORT",
        .MH_SPLIT_SEGS: "SPLIT_SEGS",
        .MH_SUBSECTIONS_VIA_SYMBOLS: "SUBSECTIONS_VIA_SYMBOLS",
        .MH_TWOLEVEL: "TWOLEVEL",
        .MH_WEAK_DEFINES: "WEAK_DEFINES"
    ]
}
