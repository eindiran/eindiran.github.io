---
layout: post
title:  "Creating `.ics` files for iCalendar in Python"
date:   2020-02-11
tags: python linux
categories: articles
---

Man, it's a bummer how hard it is to create an `.ics` file on Linux. None of the tools that can do it have particularly intuitive interfaces. One calendar tool defaults to creating an `ics` file for your whole calendar, and the only way to specify a single event only is to know the events `uid`! (I'm looking at you, Orage Calendar).
Allegedly Thunderbird supports creating single event `.ics` files out-of-the-box, but I haven't had an opportunity to try it out, so probably that's where you should look first.

But it ended up being relatively fast to throw together a script which can populate an event and then write it out using Python's `icalendar` package.

```python
#!/usr/bin/env python3
'''
create_cal_event.py

Use the icalendar package to create an .ics file.
'''
import icalendar
import uuid
from validate_email import validate_email
from datetime import datetime, timezone
from typing import List, Tuple


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
    if optional:
        attendee.params['role'] = icalendar.vText('OPT-PARTICIPANT')
    else:
        attendee.params['role'] = icalendar.vText('REQ-PARTICIPANT')
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
```

[The documentation](https://icalendar.readthedocs.io/en/latest/index.html) for the package has some more information. [The `iCalendar` specification](https://www.kanzaki.com/docs/ical/) also is very useful.
