// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public extension LoadCommand {
    struct Kind: Equatable, Hashable, RawRepresentable {

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

public extension LoadCommand.Kind {

    // MARK: Public Type Properties

    static let LC_BUILD_VERSION = LoadCommand.Kind(UInt32(MachO.LC_BUILD_VERSION))
    static let LC_CODE_SIGNATURE = LoadCommand.Kind(UInt32(MachO.LC_CODE_SIGNATURE))
    static let LC_DATA_IN_CODE = LoadCommand.Kind(UInt32(MachO.LC_DATA_IN_CODE))
    static let LC_DYLD_ENVIRONMENT = LoadCommand.Kind(UInt32(MachO.LC_DYLD_ENVIRONMENT))
    static let LC_DYLD_INFO = LoadCommand.Kind(UInt32(MachO.LC_DYLD_INFO))
    static let LC_DYLD_INFO_ONLY = LoadCommand.Kind(MachO.LC_DYLD_INFO_ONLY)
    static let LC_DYLIB_CODE_SIGN_DRS = LoadCommand.Kind(UInt32(MachO.LC_DYLIB_CODE_SIGN_DRS))
    static let LC_DYSYMTAB = LoadCommand.Kind(UInt32(MachO.LC_DYSYMTAB))
    static let LC_ENCRYPTION_INFO = LoadCommand.Kind(UInt32(MachO.LC_ENCRYPTION_INFO))
    static let LC_ENCRYPTION_INFO_64 = LoadCommand.Kind(UInt32(MachO.LC_ENCRYPTION_INFO_64))
    static let LC_FUNCTION_STARTS = LoadCommand.Kind(UInt32(MachO.LC_FUNCTION_STARTS))
    static let LC_ID_DYLIB = LoadCommand.Kind(UInt32(MachO.LC_ID_DYLIB))
    static let LC_ID_DYLINKER = LoadCommand.Kind(UInt32(MachO.LC_ID_DYLINKER))
    static let LC_LAZY_LOAD_DYLIB = LoadCommand.Kind(UInt32(MachO.LC_LAZY_LOAD_DYLIB))
    static let LC_LINKER_OPTIMIZATION_HINT = LoadCommand.Kind(UInt32(MachO.LC_LINKER_OPTIMIZATION_HINT))
    static let LC_LINKER_OPTION = LoadCommand.Kind(UInt32(MachO.LC_LINKER_OPTION))
    static let LC_LOAD_DYLIB = LoadCommand.Kind(UInt32(MachO.LC_LOAD_DYLIB))
    static let LC_LOAD_DYLINKER = LoadCommand.Kind(UInt32(MachO.LC_LOAD_DYLINKER))
    static let LC_LOAD_UPWARD_DYLIB = LoadCommand.Kind(UInt32(MachO.LC_LOAD_UPWARD_DYLIB))
    static let LC_LOAD_WEAK_DYLIB = LoadCommand.Kind(MachO.LC_LOAD_WEAK_DYLIB)
    static let LC_MAIN = LoadCommand.Kind(MachO.LC_MAIN)
    static let LC_NOTE = LoadCommand.Kind(UInt32(MachO.LC_NOTE))
    static let LC_REEXPORT_DYLIB = LoadCommand.Kind(MachO.LC_REEXPORT_DYLIB)
    static let LC_ROUTINES = LoadCommand.Kind(UInt32(MachO.LC_ROUTINES))
    static let LC_ROUTINES_64 = LoadCommand.Kind(UInt32(MachO.LC_ROUTINES_64))
    static let LC_RPATH = LoadCommand.Kind(MachO.LC_RPATH)
    static let LC_SEGMENT = LoadCommand.Kind(UInt32(MachO.LC_SEGMENT))
    static let LC_SEGMENT_64 = LoadCommand.Kind(UInt32(MachO.LC_SEGMENT_64))
    static let LC_SEGMENT_SPLIT_INFO = LoadCommand.Kind(UInt32(MachO.LC_SEGMENT_SPLIT_INFO))
    static let LC_SOURCE_VERSION = LoadCommand.Kind(UInt32(MachO.LC_SOURCE_VERSION))
    static let LC_SUB_CLIENT = LoadCommand.Kind(UInt32(MachO.LC_SUB_CLIENT))
    static let LC_SUB_FRAMEWORK = LoadCommand.Kind(UInt32(MachO.LC_SUB_FRAMEWORK))
    static let LC_SUB_LIBRARY = LoadCommand.Kind(UInt32(MachO.LC_SUB_LIBRARY))
    static let LC_SUB_UMBRELLA = LoadCommand.Kind(UInt32(MachO.LC_SUB_UMBRELLA))
    static let LC_SYMTAB = LoadCommand.Kind(UInt32(MachO.LC_SYMTAB))
    static let LC_THREAD = LoadCommand.Kind(UInt32(MachO.LC_THREAD))
    static let LC_TWOLEVEL_HINTS = LoadCommand.Kind(UInt32(MachO.LC_TWOLEVEL_HINTS))
    static let LC_UNIXTHREAD = LoadCommand.Kind(UInt32(MachO.LC_UNIXTHREAD))
    static let LC_UUID = LoadCommand.Kind(UInt32(MachO.LC_UUID))
    static let LC_VERSION_MIN_IPHONEOS = LoadCommand.Kind(UInt32(MachO.LC_VERSION_MIN_IPHONEOS))
    static let LC_VERSION_MIN_MACOSX = LoadCommand.Kind(UInt32(MachO.LC_VERSION_MIN_MACOSX))
    static let LC_VERSION_MIN_TVOS = LoadCommand.Kind(UInt32(MachO.LC_VERSION_MIN_TVOS))
    static let LC_VERSION_MIN_WATCHOS = LoadCommand.Kind(UInt32(MachO.LC_VERSION_MIN_WATCHOS))
}

// swiftlint:enable identifier_name

// MARK: - CustomStringConvertible

extension LoadCommand.Kind: CustomStringConvertible {
    public var description: String {
        guard
            let name = LoadCommand.Kind.kindNames[self]
            else { return "LC_??? (\(rawValue))" }

        return name
    }

    // MARK: Private Type Properties

    private static let kindNames: [LoadCommand.Kind: String] = [
        .LC_BUILD_VERSION: "LC_BUILD_VERSION",
        .LC_CODE_SIGNATURE: "LC_CODE_SIGNATURE",
        .LC_DATA_IN_CODE: "LC_DATA_IN_CODE",
        .LC_DYLD_ENVIRONMENT: "LC_DYLD_ENVIRONMENT",
        .LC_DYLD_INFO_ONLY: "LC_DYLD_INFO_ONLY",
        .LC_DYLD_INFO: "LC_DYLD_INFO",
        .LC_DYLIB_CODE_SIGN_DRS: "LC_DYLIB_CODE_SIGN_DRS",
        .LC_DYSYMTAB: "LC_DYSYMTAB",
        .LC_ENCRYPTION_INFO_64: "LC_ENCRYPTION_INFO_64",
        .LC_ENCRYPTION_INFO: "LC_ENCRYPTION_INFO",
        .LC_FUNCTION_STARTS: "LC_FUNCTION_STARTS",
        .LC_ID_DYLIB: "LC_ID_DYLIB",
        .LC_ID_DYLINKER: "LC_ID_DYLINKER",
        .LC_LAZY_LOAD_DYLIB: "LC_LAZY_LOAD_DYLIB",
        .LC_LINKER_OPTIMIZATION_HINT: "LC_LINKER_OPTIMIZATION_HINT",
        .LC_LINKER_OPTION: "LC_LINKER_OPTION",
        .LC_LOAD_DYLIB: "LC_LOAD_DYLIB",
        .LC_LOAD_DYLINKER: "LC_LOAD_DYLINKER",
        .LC_LOAD_UPWARD_DYLIB: "LC_LOAD_UPWARD_DYLIB",
        .LC_LOAD_WEAK_DYLIB: "LC_LOAD_WEAK_DYLIB",
        .LC_MAIN: "LC_MAIN",
        .LC_NOTE: "LC_NOTE",
        .LC_REEXPORT_DYLIB: "LC_REEXPORT_DYLIB",
        .LC_ROUTINES_64: "LC_ROUTINES_64",
        .LC_ROUTINES: "LC_ROUTINES",
        .LC_RPATH: "LC_RPATH",
        .LC_SEGMENT_64: "LC_SEGMENT_64",
        .LC_SEGMENT_SPLIT_INFO: "LC_SEGMENT_SPLIT_INFO",
        .LC_SEGMENT: "LC_SEGMENT",
        .LC_SOURCE_VERSION: "LC_SOURCE_VERSION",
        .LC_SUB_CLIENT: "LC_SUB_CLIENT",
        .LC_SUB_FRAMEWORK: "LC_SUB_FRAMEWORK",
        .LC_SUB_LIBRARY: "LC_SUB_LIBRARY",
        .LC_SUB_UMBRELLA: "LC_SUB_UMBRELLA",
        .LC_SYMTAB: "LC_SYMTAB",
        .LC_THREAD: "LC_THREAD",
        .LC_TWOLEVEL_HINTS: "LC_TWOLEVEL_HINTS",
        .LC_UNIXTHREAD: "LC_UNIXTHREAD",
        .LC_UUID: "LC_UUID",
        .LC_VERSION_MIN_IPHONEOS: "LC_VERSION_MIN_IPHONEOS",
        .LC_VERSION_MIN_MACOSX: "LC_VERSION_MIN_MACOSX",
        .LC_VERSION_MIN_TVOS: "LC_VERSION_MIN_TVOS",
        .LC_VERSION_MIN_WATCHOS: "LC_VERSION_MIN_WATCHOS"
    ]
}
