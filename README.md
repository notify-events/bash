# Bash script for Notify.Events

A simple bash script that simplifies the process of integrating your project with the [Notify.Events](https://notify.events) service to send messages to your channels.

#### Instruction on another languages

- [Русский](/README_RU.md)

# Using instructions

To send a message using a bash script, you need to:
- Add the [Bash source](https://notify.events/ru/source/67) to your Notify.Events channel and get your `token` 
- Place the [notify.events.sh](/notify.events.sh) script file into environment which have Internet connection
- Run the script passing the necessary parameters

Usage example:
```
./notify.events.sh \
    --token=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
    --text="Hello world" \
    --priority=high \
    --image=/var/log/hourly.jpg \
    --image=/var/log/weekly.jpg \
    --file=/var/log/summary.log
```

# List of available parameters

| Parameter  | Required | Description                                 |
|------------|----------|---------------------------------------------|
| --token    | true     | param to specify your Notify.Events `token` |
| --text     | true     | param to specify message text               |
| --title    | false    | message title                               |
| --priority | false    | message priority (default: normal)          |
| --level    | false    | message level (default: info)               |
| --file     | false    | attach local file                           |
| --image    | false    | attach local image                          |

Available values for the `--priority` parameter: `highest`, `high`, `normal`, `low`, `lowest`.

Available values for the `--level` parameter: `verbose`, `info`, `notice`, `warning`, `error`, `success`.

You can use the `--file` and `--image` parameters several times in one call to attach multiple files to your message.

Use the `--help` parameter to display script usage instructions.