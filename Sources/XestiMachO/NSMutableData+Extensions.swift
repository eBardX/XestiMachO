// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public extension NSMutableData {

    // MARK: Public Instance Methods

    func bindMutable<T>(_: T.Type) -> UnsafeMutablePointer<T>? {
        guard
            length >= MemoryLayout<T>.size
            else { return nil }

        return mutableBytes.bindMemory(to: T.self,
                                       capacity: 1)
    }

    func extractBuildVersionCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<build_version_command> {
        guard
            let mptr = bindMutable(build_version_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_build_version_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractDyldInfoCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<dyld_info_command> {
        guard
            let mptr = bindMutable(dyld_info_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_dyld_info_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractDylibCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<dylib_command> {
        guard
            let mptr = bindMutable(dylib_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_dylib_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractDylinkerCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<dylinker_command> {
        guard
            let mptr = bindMutable(dylinker_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_dylinker_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractDysymtabCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<dysymtab_command> {
        guard
            let mptr = bindMutable(dysymtab_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_dysymtab_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractEncryptionInfoCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<encryption_info_command> {
        guard
            let mptr = bindMutable(encryption_info_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_encryption_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractEncryptionInfoCommand64(_ isSwapped: Bool) throws -> UnsafeMutablePointer<encryption_info_command_64> {
        guard
            let mptr = bindMutable(encryption_info_command_64.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_encryption_command_64(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractEntryPointCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<entry_point_command> {
        guard
            let mptr = bindMutable(entry_point_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_entry_point_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractFatArch(_ isSwapped: Bool) throws -> UnsafeMutablePointer<fat_arch> {
        guard
            let mptr = bindMutable(fat_arch.self)
            else { throw MachObject.Error.badFatArch }

        if isSwapped {
            swap_fat_arch(mptr, 1, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractFatArch64(_ isSwapped: Bool) throws -> UnsafeMutablePointer<fat_arch_64> {
        guard
            let mptr = bindMutable(fat_arch_64.self)
            else { throw MachObject.Error.badFatArch }

        if isSwapped {
            swap_fat_arch_64(mptr, 1, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractFatHeader(_ isSwapped: Bool) throws -> UnsafeMutablePointer<fat_header> {
        guard
            let mptr = bindMutable(fat_header.self)
            else { throw MachObject.Error.badFatHeader }

        if isSwapped {
            swap_fat_header(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractLinkeditDataCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<linkedit_data_command> {
        guard
            let mptr = bindMutable(linkedit_data_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_linkedit_data_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractLinkerOptionCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<linker_option_command> {
        guard
            let mptr = bindMutable(linker_option_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_linker_option_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractLoadCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<load_command> {
        guard
            let mptr = bindMutable(load_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_load_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractMachHeader(_ isSwapped: Bool) throws -> UnsafeMutablePointer<mach_header> {
        guard
            let mptr = bindMutable(mach_header.self)
            else { throw MachObject.Error.badMachHeader }

        if isSwapped {
            swap_mach_header(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractMachHeader64(_ isSwapped: Bool) throws -> UnsafeMutablePointer<mach_header_64> {
        guard
            let mptr = bindMutable(mach_header_64.self)
            else { throw MachObject.Error.badMachHeader }

        if isSwapped {
            swap_mach_header_64(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractNoteCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<note_command> {
        guard
            let mptr = bindMutable(note_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_note_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractRoutinesCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<routines_command> {
        guard
            let mptr = bindMutable(routines_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_routines_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractRoutinesCommand64(_ isSwapped: Bool) throws -> UnsafeMutablePointer<routines_command_64> {
        guard
            let mptr = bindMutable(routines_command_64.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_routines_command_64(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractRpathCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<rpath_command> {
        guard
            let mptr = bindMutable(rpath_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_rpath_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSegmentCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<segment_command> {
        guard
            let mptr = bindMutable(segment_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_segment_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSegmentCommand64(_ isSwapped: Bool) throws -> UnsafeMutablePointer<segment_command_64> {
        guard
            let mptr = bindMutable(segment_command_64.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_segment_command_64(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSourceVersionCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<source_version_command> {
        guard
            let mptr = bindMutable(source_version_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_source_version_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractString(at offset: Int) throws -> String {
        guard
            offset >= 0,
            offset <= length
            else { throw MachObject.Error.badLoadCommand }

        let mptr = mutableBytes.bindMemory(to: UInt8.self,
                                           capacity: length)
        let tmpArray = [UInt8](UnsafeBufferPointer(start: mptr.advanced(by: offset),
                                                   count: length - offset))

        guard
            let string = String(bytes: tmpArray.compactMap { $0 > 0 ? $0 : nil },
                                encoding: .utf8)
            else { throw MachObject.Error.badLoadCommand }

        return string
    }

    func extractSubClientCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<sub_client_command> {
        guard
            let mptr = bindMutable(sub_client_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_sub_client_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSubFrameworkCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<sub_framework_command> {
        guard
            let mptr = bindMutable(sub_framework_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_sub_framework_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSubLibraryCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<sub_library_command> {
        guard
            let mptr = bindMutable(sub_library_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_sub_library_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSubUmbrellaCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<sub_umbrella_command> {
        guard
            let mptr = bindMutable(sub_umbrella_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_sub_umbrella_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractSymtabCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<symtab_command> {
        guard
            let mptr = bindMutable(symtab_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_symtab_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractThreadCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<thread_command> {
        guard
            let mptr = bindMutable(thread_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_thread_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractTwolevelHintsCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<twolevel_hints_command> {
        guard
            let mptr = bindMutable(twolevel_hints_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_twolevel_hints_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractUuidCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<uuid_command> {
        guard
            let mptr = bindMutable(uuid_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_uuid_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }

    func extractVersionMinCommand(_ isSwapped: Bool) throws -> UnsafeMutablePointer<version_min_command> {
        guard
            let mptr = bindMutable(version_min_command.self)
            else { throw MachObject.Error.badLoadCommand }

        if isSwapped {
            swap_version_min_command(mptr, NX_UnknownByteOrder)
        }

        return mptr
    }
}
