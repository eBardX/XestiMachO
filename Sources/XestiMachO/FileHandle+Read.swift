// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public extension FileHandle {

    // MARK: Public Instance Methods

    func readFatArchs(for header: FatHeader) throws -> [FatArch] {
        let fasOffset = header.offset + UInt64(header.size)
        let magic = header.magic

        var faOffset = UInt64(0)
        var archs: [FatArch] = []

        for _ in 1...header.archCount {
            let arch: FatArch

            if magic.is64Bit {
                let faSize = UInt32(MemoryLayout<fat_arch_64>.size)
                let faItem = try _readItem(fat_arch_64.self,
                                           from: fasOffset + faOffset,
                                           for: faSize,
                                           isSwapped: magic.isSwapped) {
                                            swap_fat_arch_64($0, 1, $1)
                }

                arch = try FatArch(item: faItem)
            } else {
                let faSize = UInt32(MemoryLayout<fat_arch>.size)
                let faItem = try _readItem(fat_arch.self,
                                           from: fasOffset + faOffset,
                                           for: faSize,
                                           isSwapped: magic.isSwapped) {
                                            swap_fat_arch($0, 1, $1)
                }

                arch = try FatArch(item: faItem)
            }

            archs.append(arch)

            faOffset += UInt64(arch.size)
        }

        return archs
    }

    func readFatHeader(with magic: Magic) throws -> FatHeader {
        let size = UInt32(MemoryLayout<fat_header>.size)
        let item = try _readItem(fat_header.self,
                                 from: 0,
                                 for: size,
                                 isSwapped: magic.isSwapped,
                                 swapper: swap_fat_header)

        return try FatHeader(item: item,
                             magic: magic)
    }

    func readLoadCommands(for header: MachHeader) throws -> [LoadCommand] {
        let lcsOffset = header.offset + UInt64(header.size)
        let magic = header.magic
        let lcsData = try _readMutableData(from: lcsOffset,
                                           for: header.totalCommandSize)

        var commands: [LoadCommand] = []
        var lcOffset: UInt64 = 0

        let tmpSize = MemoryLayout<load_command>.size

        for _ in 1...header.commandCount {
            let rawPtr = lcsData.mutableBytes.advanced(by: Int(lcOffset))
            let tmpData = NSMutableData(bytes: rawPtr,
                                        length: tmpSize)
            let tmpPtr = try tmpData.extractLoadCommand(magic.isSwapped)
            let lcKind = LoadCommand.Kind(tmpPtr.pointee.cmd)
            let lcSize = tmpPtr.pointee.cmdsize
            let lcData = NSMutableData(bytes: rawPtr,
                                       length: Int(lcSize))
            let command = try _makeLoadCommand(offset: lcsOffset + lcOffset,
                                               kind: lcKind,
                                               data: lcData,
                                               isSwapped: magic.isSwapped)

            commands.append(command)

            lcOffset += UInt64(lcSize)
        }

        return commands
    }

    func readMachHeader(at offset: UInt64,
                        with magic: Magic) throws -> MachHeader {
        if magic.is64Bit {
            let mhSize = UInt32(MemoryLayout<mach_header_64>.size)
            let mhItem = try _readItem(mach_header_64.self,
                                       from: offset,
                                       for: mhSize,
                                       isSwapped: magic.isSwapped,
                                       swapper: swap_mach_header_64)

            return try MachHeader(item: mhItem,
                                  magic: magic)
        } else {
            let mhSize = UInt32(MemoryLayout<mach_header>.size)
            let mhItem = try _readItem(mach_header.self,
                                       from: offset,
                                       for: mhSize,
                                       isSwapped: magic.isSwapped,
                                       swapper: swap_mach_header)

            return try MachHeader(item: mhItem,
                                  magic: magic)
        }
    }

    func readMagic(at offset: UInt64) throws -> Magic {
        let mdata = try _readMutableData(from: offset,
                                         for: UInt32(MemoryLayout<UInt32>.size))

        guard
            let mptr = mdata.bindMutable(UInt32.self)
            else { throw MachObject.Error.badMagic }

        return try Magic(mptr.pointee)
    }

    // MARK: Private Instance Methods

    private func _makeLoadCommand(offset: UInt64,
                                  kind: LoadCommand.Kind,
                                  data: NSMutableData,
                                  isSwapped: Bool) throws -> LoadCommand {
        switch kind {
            // case .LC_BUILD_VERSION:
            //    let item = try Item(build_version_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_build_version_command)
            //
            //    return BuildVersionCommand(item: item)

        case .LC_CODE_SIGNATURE,
             .LC_DATA_IN_CODE,
             .LC_DYLIB_CODE_SIGN_DRS,
             .LC_FUNCTION_STARTS,
             .LC_LINKER_OPTIMIZATION_HINT,
             .LC_SEGMENT_SPLIT_INFO:
            let item = try Item(linkedit_data_command.self,
                                offset: offset,
                                data: data,
                                isSwapped: isSwapped,
                                swapper: swap_linkedit_data_command)

            return try LinkeditDataCommand(item: item)

            // case .LC_DYLD_ENVIRONMENT,
            //     .LC_ID_DYLINKER,
            //     .LC_LOAD_DYLINKER:
            //    let item = try Item(dylinker_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_dylinker_command)
            //
            //    return try DylinkerCommand(item: item)

            // case .LC_DYLD_INFO,
            //     .LC_DYLD_INFO_ONLY:
            //    let item = try Item(dyld_info_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_dyld_info_command)
            //
            //    return try DyldInfoCommand(item: item)

            // case .LC_DYSYMTAB:
            //    let item = try Item(dysymtab_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_dysymtab_command)
            //
            //    return try DysymtabCommand(item: item)

            // case .LC_ENCRYPTION_INFO:
            //    let item = try Item(encryption_info_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_encryption_command)
            //
            //    return try EncryptionInfoCommand(item: item)

            // case .LC_ENCRYPTION_INFO_64:
            //    let item = try Item(encryption_info_command_64.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_encryption_command_64)
            //
            //    return try EncryptionInfoCommand(item: item)

        case .LC_ID_DYLIB,
             .LC_LOAD_DYLIB,
             .LC_LOAD_WEAK_DYLIB,
             .LC_REEXPORT_DYLIB:
            let item = try Item(dylib_command.self,
                                offset: offset,
                                data: data,
                                isSwapped: isSwapped,
                                swapper: swap_dylib_command)

            return try DylibCommand(item: item)

            // case .LC_LINKER_OPTION:
            //    let item = try Item(linker_option_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_linker_option_command)
            //
            //    return try LinkerOptionCommand(item: item)

            // case .LC_MAIN:
            //    let item = try Item(entry_point_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_entry_point_command)
            //
            //    return try EntryPointCommand(item: item)

            // case .LC_NOTE:
            //    let item = try Item(note_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_note_command)
            //
            //    return try NoteCommand(item: item)

            // case .LC_ROUTINES:
            //    let item = try Item(routines_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_routines_command)
            //
            //    return try RoutinesCommand(item: item)

            // case .LC_ROUTINES_64:
            //    let item = try Item(routines_command_64.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_routines_command_64)
            //
            //    return try RoutinesCommand(item: item)

        case .LC_RPATH:
            let item = try Item(rpath_command.self,
                                offset: offset,
                                data: data,
                                isSwapped: isSwapped,
                                swapper: swap_rpath_command)

            return try RpathCommand(item: item)

        case .LC_SEGMENT:
            let item = try Item(segment_command.self,
                                offset: offset,
                                data: data,
                                isSwapped: isSwapped,
                                swapper: swap_segment_command)

            return try SegmentCommand(item: item)

        case .LC_SEGMENT_64:
            let item = try Item(segment_command_64.self,
                                offset: offset,
                                data: data,
                                isSwapped: isSwapped,
                                swapper: swap_segment_command_64)

            return try SegmentCommand(item: item)

            // case .LC_SOURCE_VERSION:
            //    let item = try Item(source_version_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_source_version_command)
            //
            //    return try SourceVersionCommand(item: item)

            // case .LC_SUB_CLIENT:
            //    let item = try Item(sub_client_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_sub_client_command)
            //
            //    return try SubClientCommand(item: item)

            // case .LC_SUB_FRAMEWORK:
            //    let item = try Item(sub_framework_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_sub_framework_command)
            //
            //    return try SubFrameworkCommand(item: item)

            // case .LC_SUB_LIBRARY:
            //    let item = try Item(sub_library_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_sub_library_command)
            //
            //    return try SubLibraryCommand(item: item)

            // case .LC_SUB_UMBRELLA:
            //    let item = try Item(sub_umbrella_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_sub_umbrella_command)
            //
            //    return try SubUmbrellaCommand(item: item)

        case .LC_SYMTAB:
            let item = try Item(symtab_command.self,
                                offset: offset,
                                data: data,
                                isSwapped: isSwapped,
                                swapper: swap_symtab_command)

            return try SymtabCommand(item: item)

            // case .LC_THREAD,
            //     .LC_UNIXTHREAD:
            //    let item = try Item(thread_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_thread_command)
            //
            //    return try ThreadCommand(item: item)

            // case .LC_TWOLEVEL_HINTS:
            //    let item = try Item(twolevel_hints_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_twolevel_hints_command)
            //
            //    return try TwolevelHintsCommand(item: item)

            // case .LC_UUID:
            //    let item = try Item(uuid_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_uuid_command)
            //
            //    return try UuidCommand(item: item)

            // case .LC_VERSION_MIN_IPHONEOS,
            //     .LC_VERSION_MIN_MACOSX,
            //     .LC_VERSION_MIN_TVOS,
            //     .LC_VERSION_MIN_WATCHOS:
            //    let item = try Item(version_min_command.self,
            //                        offset: offset,
            //                        data: data,
            //                        isSwapped: isSwapped,
            //                        swapper: swap_version_min_command)
            //
            //    return try VersionMinCommand(item: item)

        default:
            return try LoadCommand(offset: offset,
                                   size: UInt32(data.length),
                                   kind: kind,
                                   rawData: data)
        }
    }

    private func _readItem<T>(_: T.Type,
                              from offset: UInt64,
                              for size: UInt32,
                              isSwapped: Bool = false,
                              swapper: ((UnsafeMutablePointer<T>, NXByteOrder) -> Void)? = nil) throws -> Item<T> {
        return try Item(T.self,
                        offset: offset,
                        data: try _readMutableData(from: offset,
                                                   for: size),
                        isSwapped: isSwapped,
                        swapper: swapper)
    }

    private func _readMutableData(from offset: UInt64,
                                  for size: UInt32) throws -> NSMutableData {
        seek(toFileOffset: offset)

        let data = readData(ofLength: Int(size)) as NSData

        guard
            data.length >= size,
            let mdata = data.mutableCopy(with: nil) as? NSMutableData
            else { throw MachObject.Error.badRead }

        return mdata
    }
}
