#!/bin/bash

total=$(pacman -Q | wc -l)
explicit=$(pacman -Qe | wc -l)
dependencies=$(pacman -Qd | wc -l)
foreign=$(pacman -Qm | wc -l)

echo "📦 Package Count:"
echo "  Total:        $total"
echo "  Explicit:     $explicit"
echo "  Dependencies: $dependencies"
echo "  AUR/Foreign:  $foreign"
