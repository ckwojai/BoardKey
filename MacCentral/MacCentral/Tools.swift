//
//  Tools.swift
//  MacCentral
//
//  Created by Wilson Chang on 5/15/18.
//  Copyright © 2018 Wilson Chang. All rights reserved.
//

import Foundation
    func keyboardKeyDown(key: CGKeyCode) {
        let source = CGEventSource(stateID: .hidSystemState)
        let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
        event?.post(tap: .cghidEventTap)
    }
    
    func executeKeypress (value: String)
    {
        print("Executing Keypress")
        keyboardKeyDown(key: str2code(str: value))
    }
func str2code(str: String) -> CGKeyCode {
    switch (str) {
    case ("A"): return                     0x00
    case ("S"): return                     0x01
    case ("D"): return                     0x02
    case ("F"): return                     0x03
    case ("H"): return                     0x04
    case ("G"): return                     0x05
    case ("Z"): return                     0x06
    case ("X"): return                     0x07
    case ("C"): return                     0x08
    case ("V"): return                     0x09
    case ("B"): return                     0x0B
    case ("Q"): return                     0x0C
    case ("W"): return                     0x0D
    case ("E"): return                     0x0E
    case ("R"): return                     0x0F
    case ("Y"): return                     0x10
    case ("T"): return                     0x11
    case ("1"): return                     0x12
    case ("2"): return                     0x13
    case ("3"): return                     0x14
    case ("4"): return                     0x15
    case ("6"): return                     0x16
    case ("5"): return                     0x17
    case ("="): return                 0x18
    case ("9"): return                     0x19
    case ("7"): return                     0x1A
    case ("-"): return                 0x1B
    case ("8"): return                     0x1C
    case ("0"): return                     0x1D
    case ("]"): return          0x1E
    case ("O"): return                     0x1F
    case ("U"): return                     0x20
    case ("["): return           0x21
    case ("I"): return                     0x22
    case ("P"): return                     0x23
    case ("L"): return                     0x25
    case ("J"): return                     0x26
    case ("'"): return                 0x27
    case ("K"): return                     0x28
    case (";"): return             0x29
    case ("\\"): return             0x2A
    case (","): return                 0x2B
    case ("/"): return                 0x2C
    case ("N"): return                     0x2D
    case ("M"): return                     0x2E
    case ("."): return                0x2F
    case ("`"): return                 0x32
    case ("."): return         0x41
    case ("return"): return                     0x24
    case ("tab"): return                       0x30
    case("space"): return                    0x31
    case("delete"): return                   0x33
    case("caps lock"): return                 0x39
    default:
        return 0x00
    };
}
