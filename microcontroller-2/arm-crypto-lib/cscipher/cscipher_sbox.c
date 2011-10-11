/* cscipher_sbox.c */
/*
    This file is part of the AVM-Crypto-Lib.
    Copyright (C) 2006-2010 Daniel Otte (daniel.otte@rub.de)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdint.h>

const uint8_t cscipher_sbox[] = {
	0x29, 0x0d, 0x61, 0x40, 0x9c, 0xeb, 0x9e, 0x8f, 0x1f, 0x85, 0x5f, 0x58, 0x5b, 0x01, 0x39, 0x86,
	0x97, 0x2e, 0xd7, 0xd6, 0x35, 0xae, 0x17, 0x16, 0x21, 0xb6, 0x69, 0x4e, 0xa5, 0x72, 0x87, 0x08,
	0x3c, 0x18, 0xe6, 0xe7, 0xfa, 0xad, 0xb8, 0x89, 0xb7, 0x00, 0xf7, 0x6f, 0x73, 0x84, 0x11, 0x63,
	0x3f, 0x96, 0x7f, 0x6e, 0xbf, 0x14, 0x9d, 0xac, 0xa4, 0x0e, 0x7e, 0xf6, 0x20, 0x4a, 0x62, 0x30,
	0x03, 0xc5, 0x4b, 0x5a, 0x46, 0xa3, 0x44, 0x65, 0x7d, 0x4d, 0x3d, 0x42, 0x79, 0x49, 0x1b, 0x5c,
	0xf5, 0x6c, 0xb5, 0x94, 0x54, 0xff, 0x56, 0x57, 0x0b, 0xf4, 0x43, 0x0c, 0x4f, 0x70, 0x6d, 0x0a,
	0xe4, 0x02, 0x3e, 0x2f, 0xa2, 0x47, 0xe0, 0xc1, 0xd5, 0x1a, 0x95, 0xa7, 0x51, 0x5e, 0x33, 0x2b,
	0x5d, 0xd4, 0x1d, 0x2c, 0xee, 0x75, 0xec, 0xdd, 0x7c, 0x4c, 0xa6, 0xb4, 0x78, 0x48, 0x3a, 0x32,
	0x98, 0xaf, 0xc0, 0xe1, 0x2d, 0x09, 0x0f, 0x1e, 0xb9, 0x27, 0x8a, 0xe9, 0xbd, 0xe3, 0x9f, 0x07,
	0xb1, 0xea, 0x92, 0x93, 0x53, 0x6a, 0x31, 0x10, 0x80, 0xf2, 0xd8, 0x9b, 0x04, 0x36, 0x06, 0x8e,
	0xbe, 0xa9, 0x64, 0x45, 0x38, 0x1c, 0x7a, 0x6b, 0xf3, 0xa1, 0xf0, 0xcd, 0x37, 0x25, 0x15, 0x81,
	0xfb, 0x90, 0xe8, 0xd9, 0x7b, 0x52, 0x19, 0x28, 0x26, 0x88, 0xfc, 0xd1, 0xe2, 0x8c, 0xa0, 0x34,
	0x82, 0x67, 0xda, 0xcb, 0xc7, 0x41, 0xe5, 0xc4, 0xc8, 0xef, 0xdb, 0xc3, 0xcc, 0xab, 0xce, 0xed,
	0xd0, 0xbb, 0xd3, 0xd2, 0x71, 0x68, 0x13, 0x12, 0x9a, 0xb3, 0xc2, 0xca, 0xde, 0x77, 0xdc, 0xdf,
	0x66, 0x83, 0xbc, 0x8d, 0x60, 0xc6, 0x22, 0x23, 0xb2, 0x8b, 0x91, 0x05, 0x76, 0xcf, 0x74, 0xc9,
	0xaa, 0xf1, 0x99, 0xa8, 0x59, 0x50, 0x3b, 0x2a, 0xfe, 0xf9, 0x24, 0xb0, 0xba, 0xfd, 0xf8, 0x55
};
