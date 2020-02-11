---
layout: post
title:  "Creating `.ics` files for iCalendar in Python"
date:   2020-02-11
tags: python linux
categories: articles
---

Man, it's a bummer how hard it is to create an `.ics` file on Linux. None of the tools that can do it have particularly intuitive interfaces. One calendar tool defaults to creating an `ics` file for your whole calendar, and the only way to specify a single event only is to know the events `uid`! (I'm looking at you, Orage Calendar).
Allegedly Thunderbird supports creating single event `.ics` files out-of-the-box, but I haven't had an opportunity to try it out, so probably that's where you should look first.

But it ended up being relatively fast to throw together a script which can populate an event and then write it out using Python's `icalendar` package. Here is the script:


##### create_ical_event.py script
```python
#!/usr/bin/env python3
'''
create_ical_event.py

Use the icalendar package to create an iCalendar `.ics` file for a single event.


usage: create_cal_event.py [-h] --start START --end END --name EVENT_NAME
                           --description DESCRIPTION --organizer ORGANIZER
                           --attendees [ATTENDEES [ATTENDEES ...]]
                           [--file OUTPUT]


optional arguments:
  -h, --help            show this help message and exit
  --start START, -s START
                        The start time of the meeting, given as an ISO-8601
                        timestamp (UTC).
  --end END, -e END     The end time of the meeting, given as an ISO-8601
                        timestamp (UTC).
  --name EVENT_NAME, -n EVENT_NAME
                        The name of the event, used to populate the SUMMARY
                        field.
  --description DESCRIPTION, -d DESCRIPTION
                        Description/notes for event. Used to populate the
                        DESCRIPTION field.
  --organizer ORGANIZER, --chair ORGANIZER, -c ORGANIZER
                        Name and email of the event-organizer, separated by a
                        comma.
  --attendees [ATTENDEES [ATTENDEES ...]], -a [ATTENDEES [ATTENDEES ...]]
                        Name and email of the attendees; given like so --
                        "Attendee1,attendee1@email.com"
                        "Attendee2,attendee2@email.com"
  --file OUTPUT, --output OUTPUT, -o OUTPUT
                        Where to write out the .ics file
'''
import argparse
import icalendar
import sys
import uuid
from validate_email import validate_email
from datetime import datetime, timezone
from typing import List, Tuple, Optional


class EmailValidationError(Exception):
    '''Throw this error if an email address is found to be invalid.'''
    def __init__(self, message):
        '''Constructor that calls the base class (Exception) constructor.'''
        super(EmailValidationError, self).__init__(message)

    def __str__(self):
        return str(self.message)


def create_attendee_record(name: str, email_address: str,
                           rsvp: bool=True,
                           optional: bool=False,
                           do_validation: bool=False) -> icalendar.vCalAddress:
    '''Create an attendee record for a given name, email pair.'''
    if do_validation and not validate_email(email_address, check_mx=True):
        raise EmailValidationError('Address `' + email_address + '` is not a valid email address')
    base_string = 'MAILTO:'
    attendee: icalendar.vCalAddress = icalendar.vCalAddress(base_string + email_address)
    attendee.params['cn'] = icalendar.vText(name)
    attendee.params['partstat'] = icalendar.vText('NEEDS-ACTION')
    # Set ROLE value
    if optional:
        attendee.params['role'] = icalendar.vText('OPT-PARTICIPANT')
    else:
        attendee.params['role'] = icalendar.vText('REQ-PARTICIPANT')
    # Set RSVP value
    if rsvp:
        attendee.params['rsvp'] = icalendar.vText('TRUE')
    else:
        attendee.params['rsvp'] = icalendar.vText('FALSE')
    return attendee


def create_organizer_record(name: str, email_address: str) -> icalendar.vCalAddress:
    '''Create an organizer record for a given name, email pair.'''
    attendee: icalendar.vCalAddress = create_attendee_record(name, email_address)
    attendee.params['partstat'] = icalendar.vText('ACCEPTED')
    attendee.params['role'] = icalendar.vText('CHAIR')
    return attendee


def format_timestamp(datetime_obj: datetime) -> str:
    '''Create a nicely formatted timestamp.'''
    return datetime_obj.strftime('%Y%m%dT%H%M%SZ')


def create_new_event(start: datetime, end: datetime, event_name: str, description: str,
                     organizer: Tuple[str, str],
                     attendee_list: List[Tuple[str, str]]) -> icalendar.Event:
    '''Create a new 'subcomponent' for icalendar.'''
    event: icalendar.Event = icalendar.Event()
    current_time: datetime = datetime.now(timezone.utc)
    uid: str = str(uuid.uuid1())
    event.add('transp', 'TRANSPARENT')
    event.add('summary', event_name)
    event.add('description', description)
    event.add('uid', uid)
    # Add various times to the event:
    event['dtstart'] = format_timestamp(start)
    event['dtend'] = format_timestamp(end)
    event['created'] = format_timestamp(current_time)
    event['last-modified'] = format_timestamp(current_time)
    event['dtstamp'] = format_timestamp(current_time)
    try:
        event.add('organizer', create_organizer_record(*organizer))
        for attendee in attendee_list:
            attendee_record = create_attendee_record(*attendee)
            event.add('attendee', attendee_record, encode=0)
    except EmailValidationError as err:
        print(err)
    return event


def write_event(event: icalendar.Event, filename: str) -> None:
    '''Write out an .ics file for an event.'''
    # Create a calendar
    cal: icalendar.Calendar = icalendar.Calendar()
    # Add event to calendar
    cal.add_component(event)
    with open(filename, 'wb') as o:
        o.write(cal.to_ical())


def write_event_tempfile(event: icalendar.Event) -> None:
    '''Write out an .ics file, in a temporary directory.'''
    # Create a calendar
    cal: icalendar.Calendar = icalendar.Calendar()
    # Add event to calendar
    cal.add_component(event)
    import tempfile
    with tempfile.TemporaryFile() as fp:
        fp.write(cal.to_ical())


def main() -> None:
    '''This function is responsible for grabbing the commandline arguments.'''
    parser_description = 'Create an iCalendar .ics file for a single event.'
    parser = argparse.ArgumentParser(description=parser_description)
    parser.add_argument('--start', '-s', dest='start', type=str, required=True,
                        help='The start time of the meeting, given as an ISO-8601 timestamp (UTC).')
    parser.add_argument('--end', '-e', dest='end', type=str, required=True,
                        help='The end time of the meeting, given as an ISO-8601 timestamp (UTC).')
    parser.add_argument('--name', '-n', dest='event_name', type=str, required=True,
                        help='The name of the event, used to populate the SUMMARY field.')
    parser.add_argument('--description', '-d', dest='description', type=str, required=True,
                        help='Description/notes for event. Used to populate the DESCRIPTION field.')
    parser.add_argument('--organizer', '--chair', '-c', dest='organizer', type=str, required=True,
                        help='Name and email of the event-organizer, separated by a comma.')
    parser.add_argument('--attendees', '-a', dest='attendees', type=str, nargs='*', required=True,
                        help='Name and email of the attendees; given like so -- ' +
                        '"Attendee1,attendee1@email.com" "Attendee2,attendee2@email.com"')
    parser.add_argument('--file', '--output', '-o', dest='output', type=str, required=False,
                        help='Where to write out the .ics file')
    args = parser.parse_args()
    # Now handle the args:
    try:
        start: datetime = datetime.strptime(args.start, '%Y%m%dT%H%M%SZ')
        end: datetime = datetime.strptime(args.end, '%Y%m%dT%H%M%SZ')
        event_name: str = args.event_name
        description: str = args.description
        organizer = tuple([x.strip() for x in args.organizer.rsplit(',', 1)])
        attendee_list = []
        for attendee_str in args.attendees:
            current_attendee = tuple([x.strip() for x in attendee_str.rsplit(',', 1)])
            attendee_list.append(current_attendee)
        output_file: Optional[str] = args.output
    except ValueError as err:
        print(err)
        sys.exit(1)
    event: icalendar.Event = create_new_event(start, end, event_name, description, organizer,
                                              attendee_list)
    if output_file:
        write_event(event, output_file)
    else:
        write_event_tempfile(event)


if __name__ == '__main__':
    main()
```

##### Example usage of the script:

```bash
# Using full length args:
./create_ical_event.py --start "20200212T004500Z" --end "20200212T013000Z" --name "Test Event" \
  --description "This is a test event" --chair "Elliott Indiran,eindiran@promptu.com" --attendees \
  "Attendee1,attendee1@gmail.com" "Attendee2,attendee2@hotmail.com" --output "$HOME/new.ics"

# Using short args:
./create_ical_event.py -s "20200212T004500Z" -e "20200212T013000Z" -n "Test Event" \
  -d "This is a test event" -c "Elliott Indiran,eindiran@promptu.com" -a "Attendee1,attendee1@gmail.com" \
  "Attendee2,attendee2@hotmail.com" -o "$HOME/new.ics"
```

##### More on the `iCal` format
Take a look at the Python package [icalendar's documentation](https://icalendar.readthedocs.io/en/latest/index.html) if you want to see what the package supports. To find out more on the `iCalendar` format and `.ics` files, check out the [`iCalendar` specification](https://www.kanzaki.com/docs/ical/).
