# Configure the command prompt
function Prompt {
    $ESC = [char]27
    $GREEN = "[32m"
    $YELLOW = "[33m"
    $END = "[0m"
    $path = (Get-Location).path.split("\\")[-3..-1] -join "\"
    $branch = $(git rev-parse --abbrev-ref HEAD)
    $branch_string = " (${ESC}${GREEN}${branch}${ESC}${END})"
    if (!$branch) {
        $branch_string = ""
    }
    " - ${ESC}${GREEN}" + $env:USERNAME + "${ESC}${END} ${ESC}${YELLOW}" + $path + "${ESC}${END}${branch_string} $ "
}

# Add custom tools/aliases to the path
$env:Path += ";${HOME}\dotfiles\windows\aliases"
