# Load user32.dll
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class User32 {
        [DllImport("user32.dll", SetLastError=true)]
        public static extern bool SetCursorPos(int x, int y);

        [DllImport("user32.dll")]
        public static extern bool GetCursorPos(out POINT lpPoint);

        public struct POINT {
            public int X;
            public int Y;
        }
    }
"@

# Function to move the mouse
function MoveMouse {
    param([int]$xOffset, [int]$yOffset)

    $point = New-Object User32+POINT
    [void][User32]::GetCursorPos([ref]$point)

    $newX = $point.X + $xOffset
    $newY = $point.Y + $yOffset

    [void][User32]::SetCursorPos($newX, $newY)
}

# Main loop
while ($true) {
    $currentTime = Get-Date
    $hour = $currentTime.Hour

    if ($hour -ge 8 -and $hour -lt 17) {
        # Move mouse 1 pixel to the left every 2 minutes
        MoveMouse -xOffset -1 -yOffset 0
        Start-Sleep -Seconds 120

        # Move mouse 1 pixel to the right 2 minutes later
        MoveMouse -xOffset 1 -yOffset 0
    }
    Start-Sleep -Seconds 120
}
