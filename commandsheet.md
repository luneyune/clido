CliDo — Command Sheet
One scheduling flag: --at. It accepts a clock time, a day, or both. No duration, no separate date/time flags.

clido add "<description>" [options]
Create a new task. Defaults to today, no time.

Flag	Description
--at <when>	When: 15:30, tomorrow, tomorrow.15:30, next-monday 09:00, +2d, 1st, 2026-07-01
--category <name>	Category label (default: inbox)
--repeat <pattern>	Repeat pattern (see below)
Examples:

bash
clido add "Buy milk" --category errands
clido add "Team sync" --at 10:00 --category work
clido add "Call dentist" --at tomorrow.09:15
clido add "Pay rent" --at 1st.09:00 --repeat month
clido add "Water plants" --repeat "every 2 days"
clido edit <id> [options]
Edit an existing task by ID. Omit a flag to leave it unchanged; pass an empty string to clear it.

Flag	Description
--desc "<text>"	Change the description
--at <when>	Change when (--at "" clears → today, no time)
--category <name>	Change the category
--repeat <pattern>	Change the repeat pattern (--repeat "" clears)
Examples:


bash
clido edit 3 --desc "Buy organic milk" --at 19:00
clido edit 3 --category personal
clido edit 3 --at tomorrow.09:00
clido edit 3 --at ""
clido today [--order <sort>]
Show today's tasks, grouped by category and sorted.

Flag	Description
--order <sort>	time, -time, category, or combos like category,-time
Examples:

bash
clido today
clido today --order time
clido today --order category
clido today --order category,-time
Default output:

text
📁 work
  10:00  Team sync

📁 personal
  18:30  Buy milk

📁 inbox
  (no time)  Call dentist
Sorting options:

time — ascending time (tasks without time last)

-time — descending time

category — alphabetical by category

Combine with commas: --order category,-time

clido list --from <when> --to <when> [options]
List tasks in a date range.

Flag	Description
--from <when>	Start of range
--to <when>	End of range
--order <sort>	Same sorting options as today
--category <name>	Filter by category
Examples:

bash
clido list --from today --to next-week
clido list --from 2026-06-07 --to 2026-06-14 --order time
clido list --from monday --to friday --category work
clido reschedule <id> --at <when>
Move a task to a new day/time. Use this instead of "done" to keep a task alive.

Examples:

bash
clido reschedule 3 --at tomorrow
clido reschedule 3 --at next-monday.09:00
clido delete <id>
Immediately remove a task (bypasses burn). Use when you finish early or want to drop it now.

bash
clido delete 3
clido cleanup
Manually trigger the burn process. Normally runs automatically at midnight.

Deletes non-repeating tasks whose date has passed

Generates the next occurrence of repeating tasks, then deletes the old row

bash
clido cleanup
clido categories
List all categories with task counts.

bash
clido categories
clido alias <name> "<command>"
Create a shortcut for a longer command.

bash
clido alias t "today --order time"
clido alias tw "today --order category"
clido alias addw "add --category work"
Subcommand	Description
clido alias list	Show all aliases
clido alias remove <name>	Delete an alias
clido alias edit	Open config in $EDITOR
Aliases are stored in ~/.clido/config.toml:

toml
[aliases]
t = "today --order time"
tw = "today --order category"
ls = "list --from today --to next-week"
addw = "add --category work"
Natural Language (--at)
Input	Meaning
15:30	Today at 15:30
tomorrow	Tomorrow, no time
tomorrow.15:30	Tomorrow at 15:30
next-monday	Next Monday, no time
next-monday.09:00	Next Monday at 09:00
+2d	Two days from now, no time
+2d.18:00	Two days from now at 18:00
1st	1st of month, no time
1st.09:00	1st of month at 09:00
2026-07-01	Explicit date, no time
2026-07-01.10:00	Explicit date at 10:00
Parsing rule: split on the last . (or a space) — left is day, right is clock. If only a clock is present, assume today. If only a day is present, no time.

Repeat Patterns (--repeat)
Pattern	Meaning
daily	Every day
every 2 days / 2 days	Every N days
week	Every week (same weekday)
every monday / monday	Every Monday
mon,wed,fri	Every Monday, Wednesday, Friday
month	Every month on the same day number
2 months	Every 2 months
1st / 15th	Every month on that day number
Examples:

bash
clido add "Water plants" --repeat "every 2 days"
clido add "Team meeting" --repeat "every wednesday" --at 10:00
clido add "Pay rent" --repeat "1st" --at 09:00
Burn Logic
At midnight (or on clido cleanup):

Non-repeating tasks with scheduled_at < today → deleted.

Repeating tasks with scheduled_at < today → next occurrence generated, old row deleted.

Storage
Tasks: ~/.clido/tasks.db (SQLite)

Config/aliases: ~/.clido/config.toml

sql
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY,
    description TEXT NOT NULL,
    scheduled_at DATETIME,          -- nullable; NULL = today, no time
    category TEXT DEFAULT 'inbox',
    repeat_pattern TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CliDo — plan today. Burn tomorrow. Move on.
