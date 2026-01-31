#!/usr/bin/env python3

import unittest

def to_decimal(nibble):
    total = 0

    for power, bit in enumerate(nibble[::-1]):
        bit = int(bit)

        total += bit * (2 ** power)

    return total


# ---------------------------------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------------------------------


class Test(unittest.TestCase):
    def test_to_decimal(self):
        self.assertEqual(to_decimal("0000"),  0)
        self.assertEqual(to_decimal("0001"),  1)
        self.assertEqual(to_decimal("0010"),  2)
        self.assertEqual(to_decimal("0011"),  3)
        self.assertEqual(to_decimal("0100"),  4)
        self.assertEqual(to_decimal("0101"),  5)
        self.assertEqual(to_decimal("0110"),  6)
        self.assertEqual(to_decimal("0111"),  7)
        self.assertEqual(to_decimal("1000"),  8)
        self.assertEqual(to_decimal("1001"),  9)
        self.assertEqual(to_decimal("1010"), 10)
        self.assertEqual(to_decimal("1011"), 11)
        self.assertEqual(to_decimal("1100"), 12)
        self.assertEqual(to_decimal("1101"), 13)
        self.assertEqual(to_decimal("1110"), 14)
        self.assertEqual(to_decimal("1111"), 15)

if __name__ == "__main__":
    unittest.main()
