# Initially from https://github.com/neilpa/cmd-colors-solarized
# Updated to use the canon mappings, not cmd-colors-solarized mappings
# cmd-colors-solarized flips the brightness to make red/brred in termcol
# be Red/DarkRed. However, the ANSI codes match red/brred to DarkRed/Red,
# which matches what you probably expected from "brighter and darker red"
# matching PS's Red/DarkRed to termcol red/brred. Canonically, we want DarkRed/Red

${private:ESC} = [char]27
# The Light/Dark differences
# TODO: Check these once https://github.com/microsoft/terminal/pull/6807 is done
${private:BG} = "White" # base3
${private:BGHIGH} = "Gray" # base02
${private:FG} = "Yellow" # base00
${private:FGSECONDARY} = "Cyan" # base1
${private:FGHIGH} = "Green" # base01

# Tell the terminal what the foreground, background, and cursor colours should be
# Using the opposite scheme's background as the cursor colour for now.
Write-Host "${ESC}]10;rgb:65/7b/83${ESC}\${ESC}]11;rgb:fd/f6/e3${ESC}\${ESC}]12;rgb:00/2b/36${ESC}\"

# Tell PowerShell the _real_ background and foreground, just in case it ever matters
$HOST.UI.RawUI.BackgroundColor = "${BG}"
$HOST.UI.RawUI.ForegroundColor = "${FG}"

# Host Foreground
$Host.PrivateData.ErrorForegroundColor = "DarkRed"
$Host.PrivateData.WarningForegroundColor = "DarkYellow"
$Host.PrivateData.DebugForegroundColor = "DarkGreen"
$Host.PrivateData.VerboseForegroundColor = "DarkBlue"
$Host.PrivateData.ProgressForegroundColor = "DarkCyan"

# Host Background
$Host.PrivateData.ErrorBackgroundColor = "${BGHIGH}"
$Host.PrivateData.WarningBackgroundColor = "${BGHIGH}"
$Host.PrivateData.DebugBackgroundColor = "${BGHIGH}"
$Host.PrivateData.VerboseBackgroundColor = "${BGHIGH}"
$Host.PrivateData.ProgressBackgroundColor = "${BGHIGH}"

# Check for PSReadline
if (Get-Module -ListAvailable -Name "PSReadline") {
	$options = Get-PSReadlineOption

	if ([System.Version](Get-Module PSReadline).Version -lt [System.Version]"2.0.0") {
		# Foreground
		$options.CommandForegroundColor = "DarkYellow"
		$options.ContinuationPromptForegroundColor = "${FG}"
		$options.DefaultTokenForegroundColor = "${FG}"
		$options.EmphasisForegroundColor = "DarkCyan"
		$options.ErrorForegroundColor = "DarkRed"
		$options.KeywordForegroundColor = "DarkGreen"
		$options.MemberForegroundColor = "${FGHIGH}"
		$options.NumberForegroundColor = "${FGHIGH}"
		$options.OperatorForegroundColor = "${FGSECONDARY}"
		$options.ParameterForegroundColor = "${FGSECONDARY}"
		$options.StringForegroundColor = "DarkBlue"
		$options.TypeForegroundColor = "${FGSECONDARY}"
		$options.VariableForegroundColor = "DarkGreen"

		# Background
		$options.CommandBackgroundColor = "${BG}"
		$options.ContinuationPromptBackgroundColor = "${BG}"
		$options.DefaultTokenBackgroundColor = "${BG}"
		$options.EmphasisBackgroundColor = "${BG}"
		$options.ErrorBackgroundColor = "${BG}"
		$options.KeywordBackgroundColor = "${BG}"
		$options.MemberBackgroundColor = "${BG}"
		$options.NumberBackgroundColor = "${BG}"
		$options.OperatorBackgroundColor = "${BG}"
		$options.ParameterBackgroundColor = "${BG}"
		$options.StringBackgroundColor = "${BG}"
		$options.TypeBackgroundColor = "${BG}"
		$options.VariableBackgroundColor = "${BG}"
	}
 else {
		# New version of PSReadline renames Foreground colors and eliminates Background
		$options.CommandColor = "DarkYellow"
		$options.ContinuationPromptColor = "${FG}"
		$options.DefaultTokenColor = "${FG}"
		$options.EmphasisColor = "DarkCyan"
		$options.ErrorColor = "DarkRed"
		$options.KeywordColor = "DarkGreen"
		$options.MemberColor = "${FGHIGH}"
		$options.NumberColor = "${FGHIGH}"
		$options.OperatorColor = "${FGSECONDARY}"
		$options.ParameterColor = "${FGSECONDARY}"
		$options.StringColor = "DarkBlue"
		$options.TypeColor = "${FGSECONDARY}"
		$options.VariableColor = "DarkGreen"
	}
}
