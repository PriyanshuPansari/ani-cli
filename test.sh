#!/bin/sh

test_ueberzug() {
    temp_file="/tmp/test.png"
    # Download a test image from a reliable source
    curl -s "https://raw.githubusercontent.com/seebye/ueberzug/master/examples/images/test.png" -o "$temp_file"
    
    # Check if download was successful
    if [ ! -s "$temp_file" ]; then
        echo "Failed to download test image"
        return 1
    fi
    
    # Check file type
    file_type=$(file -b "$temp_file")
    echo "Debug: File type: $file_type"
    
    # Try to display it
    ueberzug layer --parser json <<EOF
{"action": "add", "identifier": "preview", "x": 0, "y": 0, "path": "$temp_file"}
EOF
    
    sleep 3
    
    # Clean up
    ueberzug layer --parser json <<EOF
{"action": "remove", "identifier": "preview"}
EOF
    rm -f "$temp_file"
}

# Make sure ueberzug is installed
if ! command -v ueberzug >/dev/null; then
    echo "ueberzug is not installed"
    exit 1
fi

echo "Starting ueberzug test..."
test_ueberzug