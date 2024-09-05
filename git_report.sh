#!/bin/bash

# Display Help message
Help()
{
    echo ""
    echo "Generate Git Changes Report Since a Specific Time"
    echo ""
    echo "Usage: $0 [-v] [-s <since_input>]"
    echo
    echo "Options:"
    echo "  -v  Enable verbose mode"
    echo "  -s  Specify the time range (e.g., '24 hours ago', '3 days ago'). Default is 24 hours if not specified"
    echo
    echo "Examples:"
    echo "  $0 -v -s '2 days ago'  # Generate report for changes in the last 2 days"
    echo
    echo "Note:"
    echo "  - Time input format should be in a human-readable form (e.g., 'X minutes/hours/days/weeks ago')"
    echo "  - Invalid inputs will display an error message"
    echo
}

# Initialize variables
verbose=false
since_input="24 hours ago"
found_commits=false

# Process command line options
while getopts "hvs:" opt; do
    case "$opt" in
        h) Help; exit 0 ;;
        v) verbose=true ;;
        s) since_input="$OPTARG" ;;
        *) echo "Error: Invalid option"; exit 1 ;;
    esac
done

# Function to display debug messages
debug_message() {
    if [ "$verbose" = true ]; then
        echo "##DEBUG## $1"
    fi
}

# Initialize script directory
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd /home/autoboss/deviceConfiguration/ || { echo "Error: Unable to change directory"; exit 1; }
output_file="$script_dir/git_changes_report.md"

debug_message "variable: since_input=$since_input"
debug_message "variable: output_file=$output_file"

# Start writing the Markdown content to the output file
echo "# Git Changes Report (between $(date -d "$since_input") and $(date))" > "$output_file"
echo "" >> "$output_file"
debug_message "list of commits: git log --since=\"$since_input\" --pretty=format:\"%h|%an|%ad|%s\""

while IFS= read -r line || [[ -n "$line" ]]
do
    debug_message "line: $line"
    found_commits=true
    commit_hash=$(echo "$line" | cut -d'|' -f1)
    author=$(echo "$line" | cut -d'|' -f2)
    commit_date=$(echo "$line" | cut -d'|' -f3 | cut -d'+' -f1)

    echo "## Commit: $commit_hash - $author - $commit_date" | tee -a "$output_file"
    echo "" >> "$output_file"

    # Retrieve the list of changed files within the commit
    debug_message "list of diff files: git diff-tree --no-commit-id --name-only -r \"$commit_hash\""
    git diff-tree --no-commit-id --name-only -r "$commit_hash" | while IFS= read -r file
    do
        if [[ "$verbose" = true ]]; then
            debug_message "SN: $file"
            debug_message "diff command: git diff \"$commit_hash\"^..\"$commit_hash\" \"$file\""
        fi
        {
            echo "### SN: $file"
            echo ""
            echo "<details>"
            echo "<summary>Show Diff for $file</summary>"
            echo ""
            echo "\`\`\`"
            git diff "$commit_hash"^.."$commit_hash" -- "$file"
            echo "\`\`\`"
            echo ""
            echo "</details>"
            echo ""
        } >> "$output_file"
    done
done < <(git log --since="$since_input" --pretty=format:"%h|%an|%ad|%s")

# Check if git log provided any output
if [ "$found_commits" = false ]; then
    echo "No commits found, check the date format is valid: --since=\"$since_input\""
    echo "Exiting the script."
else
    echo ""
    echo "Script Completed, check the output: $output_file"
fi
