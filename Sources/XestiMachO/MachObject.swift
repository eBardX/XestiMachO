// © 2019 J. G. Pusey (see LICENSE.md)

 import Foundation
 import XestiPath

public final class MachObject {

    // MARK: Public Type Methods

    public static func determineArchitecture(_ path: Path) throws -> Architecture {
        let fh = try FileHandle(forReadingFrom: path.fileURL)
        let magic = try fh.readMagic(at: 0)

        if magic.isFat {
            return try fh.readFatHeader(at: 0,
                                        with: magic,
                                        full: false).architecture
        } else {
            return try fh.readMachHeader(at: 0,
                                         with: magic,
                                         full: false).architecture
        }
    }

    public static func load(_ path: Path,
                            allowUpdates: Bool = false) throws -> MachObject {
        let fh = allowUpdates ?
            try FileHandle(forUpdating: path.fileURL) :
            try FileHandle(forReadingFrom: path.fileURL)

        let magic = try fh.readMagic(at: 0)
        let header: Header

        if magic.isFat {
            header = .universal(try fh.readFatHeader(at: 0,
                                                     with: magic,
                                                     full: true))
        } else {
            header = .single(try fh.readMachHeader(at: 0,
                                                   with: magic,
                                                   full: true))
        }

        return MachObject(path: path,
                          isReadOnly: !allowUpdates,
                          fileHandle: fh,
                          header: header)
    }

    // MARK: Public Instance Properties

    public let isReadOnly: Bool
    public let path: Path

    public var architecture: Architecture {
        switch header {
        case let .single(machHeader):
            return machHeader.architecture

        case let .universal(fatHeader):
            return fatHeader.architecture
        }
    }

    // MARK: Public Instance Methods

    public func dump() {
        switch header {
        case let .single(machHeader):
            return dump(machHeader)

        case let .universal(fatHeader):
            return dump(fatHeader)
        }
    }

    public func removeCodeSignature() throws {
        guard
            !isReadOnly
            else { throw Error.readOnly }

        switch header {
        case let .single(machHeader):
            return try _removeCodeSignature(machHeader)

        case let .universal(fatHeader):
            return try _removeCodeSignature(fatHeader)
        }
    }

    // MARK: Internal Instance Properties

    internal let fileHandle: FileHandle

    // MARK: Private Nested Types

    private enum Header {
        case single(MachHeader)
        case universal(FatHeader)
    }

    // MARK: Private Initializers

    private init(path: Path,
                 isReadOnly: Bool,
                 fileHandle: FileHandle,
                 header: Header) {
        self.fileHandle = fileHandle
        self.header = header
        self.isReadOnly = isReadOnly
        self.path = path
    }

    // MARK: Private Instance Properties

    private var header: Header

    // MARK: Private Instance Methods

    private func _removeCodeSignature(_ header: FatHeader) throws {
    }

    private func _removeCodeSignature(_ header: MachHeader) throws {
    }
}
