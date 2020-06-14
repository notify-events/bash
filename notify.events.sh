#!/bin/bash

set -eu

# Print help
print_help() {
	echo "To send a message using a bash script, you need to:"
	echo "- Place the script file into environment which have Internet connection"
	echo "- Run the script passing the necessary parameters"
	echo ""
	echo "Usage: ./notyfy.events.sh --token=<your_token> --text=<message_text> [OPTION]..."
  echo ""
  echo "Available parameters:"
  echo "--token       required param to specify your token"
  echo "--text        required param to specify message text"
  echo "--title       message title"
  echo "--priority    message priority (default: normal)"
  echo "--level       message level (default: info)"
  echo "--file        attach local file"
  echo "--image       attach local image"
  echo "--help        display script usage instructions"
  echo ""
  echo "Available values for the --priority param:  highest, high, normal, low, lowest"
  echo "Available values for the --level param:     verbose, info, notice, warning, error, success"
  echo ""
  echo "You can use the --file and --image parameters several times in one call to attach multiple files to your message"
  echo ""
}

# Print error
print_error() {
	echo "ERROR: $1"
	exit 1
}

priority="normal"
level="info"
files=()
images=()

# Parse args
while [ $# -gt 0 ]; do
	case "$1" in
		--help) print_help exit 0 ;;
		--token=*) token="${1#*=}" ;;
		--text=*) text="${1#*=}" ;;
		--title=*) title="${1#*=}" ;;
		--priority=*) priority="${1#*=}" ;;
		--level=*) level="${1#*=}" ;;
		--file=*) files+=( "${1#*=}" ) ;;
		--image=*) images+=( "${1#*=}" ) ;;
		*)
			print_error "Unknown arguments"
			exit 1
	esac
	shift
done

# Check required parameters
if [[ -z ${token+x} ]]; then print_error "Token is required. Use --help to see instructions."; fi
if [[ -z ${text+x} ]];  then print_error "Text is required. Use --help to see instructions."; fi

# Check parameters value
LANG=C LC_ALL=C
if [[ ${#token} -ne 32 ]]; then print_error "Invalid token length"; fi
if [[ $priority != "highest" && $priority != "high" && $priority != "normal" && $priority != "low" && $priority != "lowest" ]]; then print_error "Invalid priority value: $priority"; fi
if [[ $level != "verbose" && $level != "info" && $level != "notice" && $level != "warning" && $level != "error" && $level != "success" ]]; then print_error "Invalid level value: $level"; fi

cmd="curl -XPOST"

if [[ ! -z ${title+x} ]]; then
	cmd+=" -d title=$title";
fi

cmd+=" -d text=$text"
cmd+=" -d priority=$priority"
cmd+=" -d level=$level"

for file in "${files[@]}"; do
	cmd+=" -F 'files[]=@$file'";
done

for image in "${images[@]}"; do
	cmd+=" -F 'images[]=@$image'";
done

cmd+=" https://notify.events/api/v1/channel/source/$token/execute"

echo $cmd