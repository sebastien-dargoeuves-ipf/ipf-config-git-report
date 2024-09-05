# Git Changes Report Script

This script generates a Markdown report of Git changes within a specified time frame.

## Requirements

Having an IP Fabric server, with the configuration management active. You should have configuration files saved in the folder /home/autoboss/deviceConfiguration/
This bash script is meant to be run on the IP Fabric server

## Usage

You can run the script with the following command:

```bash
./git_report.sh [options]
```

### Options

- `-h`: Display the help message and exit.
- `-v`: Enable verbose mode to display debug messages.
- `-s <time>`: Specify the time frame 'since' for the Git log (e.g., '24 hours ago', '2 days ago'). The default is '24 hours ago'.

### Example

```bash
# To generate a report for the last 24 hours without verbose:
./git_report.sh
# To generate a report for the last 48 hours with verbose mode enabled:
./git_report.sh -v -s "48 hours ago"
```

## Output

The script generates a Markdown file named `git_changes_report.md` in the script's directory. The report includes a list of commits made within the specified time frame.

### Sample Output

```markdown
# Git Changes Report (between Tue  3 Sep 08:12:29 UTC 2024 and Thu  5 Sep 08:12:29 UTC 2024)

## Commit: eec2069 - IP Fabric - Tue Sep 3 15:58:29 2024

### SN: a23ff65

<details>
<summary>Show Diff for a23ff65</summary>

\``` 
diff --git a/a23ff65 b/a23ff65
index ce796b3..7d40c54 100644
--- a/a23ff65
+++ b/a23ff65
@@ -310,6 +310,7 @@ interface Ethernet0/2.119
 interface Ethernet0/3
  mac-address 0200.3500.0103
  no ip address
+ shutdown
 !
 router ospf 35
  redistribute bgp 2293763 subnets
\``` 

</details>

```

## Notes

- The time input format should be in a human-readable form (e.g., 'X minutes/hours/days/weeks ago').
- Invalid inputs will display an error message.

## License

This project is licensed under the terms of the MIT license.