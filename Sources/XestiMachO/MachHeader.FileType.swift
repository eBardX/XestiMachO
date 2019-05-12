// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public extension MachHeader {
    struct FileType: Equatable, Hashable, RawRepresentable {

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
}

// MARK: -

// swiftlint:disable identifier_name

public extension MachHeader.FileType {

    // MARK: Public Type Properties

    static let MH_BUNDLE = MachHeader.FileType(UInt32(MachO.MH_BUNDLE))
    static let MH_CORE = MachHeader.FileType(UInt32(MachO.MH_CORE))
    static let MH_DSYM = MachHeader.FileType(UInt32(MachO.MH_DSYM))
    static let MH_DYLIB = MachHeader.FileType(UInt32(MachO.MH_DYLIB))
    static let MH_DYLIB_STUB = MachHeader.FileType(UInt32(MachO.MH_DYLIB_STUB))
    static let MH_DYLINKER = MachHeader.FileType(UInt32(MachO.MH_DYLINKER))
    static let MH_EXECUTE = MachHeader.FileType(UInt32(MachO.MH_EXECUTE))
    static let MH_FVMLIB = MachHeader.FileType(UInt32(MachO.MH_FVMLIB))
    static let MH_KEXT_BUNDLE = MachHeader.FileType(UInt32(MachO.MH_KEXT_BUNDLE))
    static let MH_OBJECT = MachHeader.FileType(UInt32(MachO.MH_OBJECT))
    static let MH_PRELOAD = MachHeader.FileType(UInt32(MachO.MH_PRELOAD))
}

// swiftlint:enable identifier_name

// MARK: -

public extension MachHeader.FileType {

    // MARK: Public Instance Properties

    var briefDescription: String {
        guard
            let name = MachHeader.FileType.briefFileTypeNames[self]
            else { return String(describing: rawValue) }

        return name
    }

    // MARK: Private Type Properties

    private static let briefFileTypeNames: [MachHeader.FileType: String] = [
        .MH_BUNDLE: "BUNDLE",
        .MH_CORE: "CORE",
        .MH_DSYM: "DSYM",
        .MH_DYLIB_STUB: "DYLIB_STUB",
        .MH_DYLIB: "DYLIB",
        .MH_DYLINKER: "DYLINKER",
        .MH_EXECUTE: "EXECUTE",
        .MH_FVMLIB: "FVMLIB",
        .MH_KEXT_BUNDLE: "KEXTBUNDLE",
        .MH_OBJECT: "OBJECT",
        .MH_PRELOAD: "PRELOAD"
    ]
}

// MARK: - CustomStringConvertible

extension MachHeader.FileType: CustomStringConvertible {
    public var description: String {
        guard
            let name = MachHeader.FileType.fileTypeNames[self]
            else { return "MH_??? (\(rawValue))" }

        return name
    }

    // MARK: Private Type Properties

    private static let fileTypeNames: [MachHeader.FileType: String] = [
        .MH_BUNDLE: "MH_BUNDLE",
        .MH_CORE: "MH_CORE",
        .MH_DSYM: "MH_DSYM",
        .MH_DYLIB_STUB: "MH_DYLIB_STUB",
        .MH_DYLIB: "MH_DYLIB",
        .MH_DYLINKER: "MH_DYLINKER",
        .MH_EXECUTE: "MH_EXECUTE",
        .MH_FVMLIB: "MH_FVMLIB",
        .MH_KEXT_BUNDLE: "MH_KEXT_BUNDLE",
        .MH_OBJECT: "MH_OBJECT",
        .MH_PRELOAD: "MH_PRELOAD"
    ]
}
