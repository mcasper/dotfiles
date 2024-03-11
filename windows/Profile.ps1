# Configure the command prompt
function Prompt {
    $ESC = [char]27
    $GREEN = "[32m"
    $YELLOW = "[33m"
    $END = "[0m"
    $path = (Get-Location).path.split("\\")[-3..-1] -join "\"
    $branch = $(git rev-parse --abbrev-ref HEAD)
    if ($branch.length -gt 30) {
        $branch = $branch.substring(0,30)
    }
    $branch_string = " (${ESC}${GREEN}${branch}${ESC}${END})"
    if (!$branch) {
        $branch_string = ""
    }
    " - ${ESC}${GREEN}" + $env:USERNAME + "${ESC}${END} ${ESC}${YELLOW}" + $path + "${ESC}${END}${branch_string} $ "
}

# Add custom tools/aliases to the path
$env:Path += ";${HOME}\dotfiles\windows\aliases"

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
