// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

internal struct LoadCommand: ItemDescriptor {

    // MARK: Public Initializers

    public init?(kind: Kind,
                 offset: UInt64,
                 count: Int,
                 item: Any) {
        guard
            count > 0,
            (item is dylib_command
                || item is linkedit_data_command
                || item is load_command
                || item is segment_command
                || item is segment_command_64
                || item is symtab_command)
            else { return nil }

        self.count = count
        self.item = item
        self.kind = kind
        self.offset = offset
    }

    // MARK: Public Instance Properties

    public let count: Int
    public let item: Any
    public let kind: Kind
    public let offset: UInt64
}

//public class LoadCommand {
//
//    // MARK: Public Type Methods
//
//    public static func parse(data: Data,
//                             isSwapped: Bool) -> LoadCommand? {
//        guard
//            let command = data.extractLoadCommand(isSwapped)
//            else { return nil }
//
//        switch Int32(command.cmd) {
//        case LC_CODE_SIGNATURE:
//            guard
//                let command = data.extractLinkeditDataCommand(isSwapped)
//                else { return nil }
//
//            return LinkeditDataCommand(raw: command)
//
//        case LC_LOAD_DYLIB,
//             Int32(LC_LOAD_WEAK_DYLIB):
//            guard
//                let command = data.extractDylibCommand(isSwapped)
//                else { return nil }
//
//            return DylibCommand(raw: command)
//
//        case LC_SEGMENT:
//            guard
//                let command = data.extractSegmentCommand(isSwapped)
//                else { return nil }
//
//            return SegmentCommand(raw: command)
//
//        case LC_SEGMENT_64:
//            guard
//                let command = data.extractSegmentCommand64(isSwapped)
//                else { return nil }
//
//            return SegmentCommand(raw64: command)
//
//        default:
//            return LoadCommand(raw: command)
//        }
//    }
//
//    // MARK: Public Initializers
//
//    public init(raw: load_command) {
//        self.kind = raw.cmd
//        self.size = raw.cmdsize
//    }
//
//    // MARK: Public Instance Properties
//
//    public let kind: UInt32
//    public let size: UInt32
//
//    // MARK: Internal Initializers
//
//    internal init(kind: UInt32,
//                  size: UInt32) {
//        self.kind = kind
//        self.size = size
//    }
//}
