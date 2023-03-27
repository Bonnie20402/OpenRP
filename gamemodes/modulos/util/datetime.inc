/*
 * Sasinosoft Utils
 * Copyright (c) 2017-2021 - Sasinosoft
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. 
 */

// DateTime
#if defined _Sasinosoft_DateTime_Included
    #endinput
#endif
#define _Sasinosoft_DateTime_Included

#define _Sasinosoft_DateTime_Version "1.0.0"

// Things from other (unreleased) Sasinosoft Utils files
#if !defined cell
#define cell _
#endif

#if !defined void
#define void _
#endif

#define Integer. Integer_

static void: Integer.Coerce(&cell: intValue, cell: minValue, cell: maxValue)
{
    if(intValue < minValue)
        intValue = minValue;
    
    if(intValue > maxValue)
        intValue = maxValue;
}

//
#define DateTime.   DateTime_
#define Date.       Date_
#define Time.       Time_
#define DateFormat. DateFormat_
#define TimeFormat. TimeFormat_

//
#if !defined TIME_AM
#define TIME_AM "AM"
#endif

#if !defined TIME_PM
#define TIME_PM "PM"
#endif

#if !defined TIME_AM_PM_LEN
#define TIME_AM_PM_LEN 3
#endif

#if !defined DEFAULT_DATE_FORMAT
#define DEFAULT_DATE_FORMAT DateFormat.BigEndian
#endif

#if !defined DEFAULT_TIME_FORMAT
#define DEFAULT_TIME_FORMAT TimeFormat.H24
#endif

#if !defined DEFAULT_DATE_SEPARATOR
#define DEFAULT_DATE_SEPARATOR '-'
#endif

#if !defined DEFAULT_TIME_SEPARATOR
#define DEFAULT_TIME_SEPARATOR ':'
#endif

//
const cell: DateTime.Size = 6; // Size in cells of a DateTime value

//
const cell: DateTime.Year   = 0;
const cell: DateTime.Month  = 1;
const cell: DateTime.Day    = 2;
const cell: DateTime.Hour   = 3;
const cell: DateTime.Minute = 4;
const cell: DateTime.Second = 5;

//
enum DateFormat
{
    DateFormat.BigEndian,    // Year, Month, Day
    DateFormat.LittleEndian, // Day, Month, Year
    DateFormat.MiddleEndian  // Month, Day, Year
}

//
enum TimeFormat
{
    TimeFormat.H24, // 24 hours (0-23)
    TimeFormat.H12  // 12 hours (1-12) + AM/PM
}

//
DateTime: DateTime.New(cell: year = 0, cell: month = 1, cell: day = 1, cell: hour = 0, cell: minute = 0, cell: second = 0);
DateTime: DateTime.NewDate(cell: year = 0, cell: month = 1, cell: day = 1);
DateTime: DateTime.NewTime(cell: hour = 0, cell: minute = 0, cell: second = 0);
DateTime: DateTime.Clone(const DateTime: other[DateTime.Size]);
DateTime: DateTime.Now();
DateTime: DateTime.Today();
DateTime: DateTime.CurrentTime();
cell: DateTime.GetYear(const DateTime: dateTime[DateTime.Size]);
void: DateTime.SetYear(DateTime: dateTime[DateTime.Size], cell: year);
cell: DateTime.GetMonth(const DateTime: dateTime[DateTime.Size]);
void: DateTime.SetMonth(DateTime: dateTime[DateTime.Size], cell: month);
cell: DateTime.GetDay(const DateTime: dateTime[DateTime.Size]);
void: DateTime.SetDay(DateTime: dateTime[DateTime.Size], cell: day);
cell: DateTime.GetHour(const DateTime: dateTime[DateTime.Size]);
void: DateTime.SetHour(DateTime: dateTime[DateTime.Size], cell: hour);
cell: DateTime.GetMinute(const DateTime: dateTime[DateTime.Size]);
void: DateTime.SetMinute(DateTime: dateTime[DateTime.Size], cell: minute);
cell: DateTime.GetSecond(const DateTime: dateTime[DateTime.Size]);
void: DateTime.SetSecond(DateTime: dateTime[DateTime.Size], cell: second);
cell: DateTime.Compare(const DateTime: dateTime1[DateTime.Size], const DateTime: dateTime2[DateTime.Size]);
bool: DateTime.Equals(const DateTime: dateTime1[DateTime.Size], const DateTime: dateTime2[DateTime.Size]);
cell: DateTime.GetNumberOfDays(cell: year, cell: month = 0);
void: DateTime.AddYears(DateTime: dateTime[DateTime.Size], cell: years);
void: DateTime.AddMonths(DateTime: dateTime[DateTime.Size], cell: months);
void: DateTime.AddDays(DateTime: dateTime[DateTime.Size], cell: days);
void: DateTime.AddHours(DateTime: dateTime[DateTime.Size], cell: hours);
void: DateTime.AddMinutes(DateTime: dateTime[DateTime.Size], cell: minutes);
void: DateTime.AddSeconds(DateTime: dateTime[DateTime.Size], cell: seconds);
DateTime: DateTime.ParseDate(const cell: dateString[], DateFormat: dateFormat = DEFAULT_DATE_FORMAT, cell: dateSeparator = DEFAULT_DATE_SEPARATOR);
DateTime: DateTime.ParseTime(const cell: timeString[], TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, cell: timeSeparator = DEFAULT_TIME_SEPARATOR);
DateTime: DateTime.Parse(const cell: dateTimeString[], DateFormat: dateFormat = DEFAULT_DATE_FORMAT, TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, cell: dateSeparator = DEFAULT_DATE_SEPARATOR, cell: timeSeparator = DEFAULT_TIME_SEPARATOR);
cell: DateTime.ToDateString(const DateTime: dateTime[DateTime.Size], DateFormat: dateFormat = DEFAULT_DATE_FORMAT, cell: dateSeparator = DEFAULT_DATE_SEPARATOR);
cell: DateTime.ToTimeString(const DateTime: dateTime[DateTime.Size], TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, cell: timeSeparator = DEFAULT_TIME_SEPARATOR);
cell: DateTime.ToString(const DateTime: dateTime[DateTime.Size], DateFormat: dateFormat = DEFAULT_DATE_FORMAT, TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, cell: dateSeparator = DEFAULT_DATE_SEPARATOR, cell: timeSeparator = DEFAULT_TIME_SEPARATOR);

//
stock DateTime: DateTime.New(cell: year = 0, cell: month = 1, cell: day = 1, 
    cell: hour = 0, cell: minute = 0, cell: second = 0)
{
    Integer.Coerce(month, 1, 12);
    Integer.Coerce(day, 1, DateTime.GetNumberOfDays(year, month));
    Integer.Coerce(hour, 0, 23);
    Integer.Coerce(minute, 0, 59);
    Integer.Coerce(second, 0, 59);

    new dateTime[DateTime.Size];
    dateTime[DateTime.Year] = year;
    dateTime[DateTime.Month] = month;
    dateTime[DateTime.Day] = day;
    dateTime[DateTime.Hour] = hour;
    dateTime[DateTime.Minute] = minute;
    dateTime[DateTime.Second] = second;
    return DateTime: dateTime;
}

//
stock DateTime: DateTime.NewDate(cell: year = 0, cell: month = 1, cell: day = 1)
{
    new DateTime: dateTime[DateTime.Size];
    dateTime = DateTime.New(year, month, day, 0, 0, 0);
    return dateTime;
}

//
stock DateTime: DateTime.NewTime(cell: hour = 0, cell: minute = 0, cell: second = 0)
{
    new DateTime: dateTime[DateTime.Size];
    dateTime = DateTime.New(0, 1, 1, hour, minute, second);
    return dateTime;
}

//
stock DateTime: DateTime.Clone(const DateTime: other[DateTime.Size])
{
    new DateTime: dateTime[DateTime.Size];
    dateTime = DateTime.New(cell: other[DateTime.Year], cell: other[DateTime.Month], cell: other[DateTime.Day], 
        cell: other[DateTime.Hour], cell: other[DateTime.Minute], cell: other[DateTime.Second]);
    return dateTime;
}

//
stock DateTime: DateTime.Now()
{
    new cell: year;
    new cell: month;
    new cell: day;
    new cell: hour;
    new cell: minute;
    new cell: second;
    new DateTime: dateTime[DateTime.Size];

    getdate(year, month, day);
    gettime(hour, minute, second);
    dateTime = DateTime.New(year, month, day, hour, minute, second);
    return dateTime;
}

//
stock DateTime: DateTime.Today()
{
    new cell: year;
    new cell: month;
    new cell: day;
    new DateTime: dateTime[DateTime.Size];

    getdate(year, month, day);
    dateTime = DateTime.NewDate(year, month, day);
    return dateTime;
}

//
stock DateTime: DateTime.CurrentTime()
{
    new cell: hour;
    new cell: minute;
    new cell: second;
    new DateTime: dateTime[DateTime.Size];

    gettime(hour, minute, second);
    dateTime = DateTime.NewTime(hour, minute, second);
    return dateTime;
}

//
stock cell: DateTime.GetYear(const DateTime: dateTime[DateTime.Size])
{
    return cell: dateTime[DateTime.Year];
}

stock void: DateTime.SetYear(DateTime: dateTime[DateTime.Size], cell: year)
{
    dateTime[DateTime.Year] = DateTime: year;
}

//
stock cell: DateTime.GetMonth(const DateTime: dateTime[DateTime.Size])
{
    return cell: dateTime[DateTime.Month];
}

stock void: DateTime.SetMonth(DateTime: dateTime[DateTime.Size], cell: month)
{
    Integer.Coerce(month, 1, 12);
    dateTime[DateTime.Month] = DateTime: month;
}

//
stock cell: DateTime.GetDay(const DateTime: dateTime[DateTime.Size])
{
    return cell: dateTime[DateTime.Day];
}

stock void: DateTime.SetDay(DateTime: dateTime[DateTime.Size], cell: day)
{
    Integer.Coerce(day, 1, DateTime.GetNumberOfDays(cell: dateTime[0], cell: dateTime[1]));
    dateTime[DateTime.Day] = DateTime: day;
}

//
stock cell: DateTime.GetHour(const DateTime: dateTime[DateTime.Size])
{
    return cell: dateTime[DateTime.Hour];
}

stock void: DateTime.SetHour(DateTime: dateTime[DateTime.Size], cell: hour)
{
    Integer.Coerce(hour, 0, 23);
    dateTime[DateTime.Hour] = DateTime: hour;
}

//
stock cell: DateTime.GetMinute(const DateTime: dateTime[DateTime.Size])
{
    return cell: dateTime[DateTime.Minute];
}

stock void: DateTime.SetMinute(DateTime: dateTime[DateTime.Size], cell: minute)
{
    Integer.Coerce(minute, 0, 59);
    dateTime[DateTime.Minute] = DateTime: minute;
}

//
stock cell: DateTime.GetSecond(const DateTime: dateTime[DateTime.Size])
{
    return cell: dateTime[DateTime.Second];
}

stock void: DateTime.SetSecond(DateTime: dateTime[DateTime.Size], cell: second)
{
    Integer.Coerce(second, 0, 59);
    dateTime[DateTime.Second] = DateTime: second;
}

//
stock cell: DateTime.Compare(const DateTime: dateTime1[DateTime.Size], const DateTime: dateTime2[DateTime.Size])
{
    new cell: yearDiff = cell: dateTime1[DateTime.Year] - cell: dateTime2[DateTime.Year];
    if (yearDiff != 0)
    {
        return (yearDiff > 0) ? 1 : -1;
    }

    new cell: monthDiff = cell: dateTime1[DateTime.Month] - cell: dateTime2[DateTime.Month];
    if (monthDiff != 0)
    {
        return (monthDiff > 0) ? 1 : -1;
    }

    new cell: dayDiff = cell: dateTime1[DateTime.Day] - cell: dateTime2[DateTime.Day];
    if (dayDiff != 0)
    {
        return (dayDiff > 0) ? 1 : -1;
    }

    new cell: hourDiff = cell: dateTime1[DateTime.Hour] - cell: dateTime2[DateTime.Hour];
    if (hourDiff != 0)
    {
        return (hourDiff > 0) ? 1 : -1;
    }

    new cell: minuteDiff = cell: dateTime1[DateTime.Minute] - cell: dateTime2[DateTime.Minute];
    if (minuteDiff != 0)
    {
        return (minuteDiff > 0) ? 1 : -1;
    }

    new cell: secondDiff = cell: dateTime1[DateTime.Second] - cell: dateTime2[DateTime.Second];
    if (secondDiff != 0)
    {
        return (secondDiff > 0) ? 1 : -1;
    }
    return 0;
}

//
stock bool: DateTime.Equals(const DateTime: dateTime1[DateTime.Size], const DateTime: dateTime2[DateTime.Size])
{
    return (DateTime.Compare(dateTime1, dateTime2) == 0);
}

//
stock cell: DateTime.GetNumberOfDays(cell: year, cell: month = 0)
{
    new cell: days;
    if (month != 0)
    {
        new cell: daysInMonth[13] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
        days = daysInMonth[month];

        if (month == 2)
        {
            if (year % 4 == 0)
                days = 29;
        }
    }
    else
    {
        days = 365;

        if (year % 4 == 0)
            days = 366;
    }
    return days;
}

//
stock void: DateTime.AddYears(DateTime: dateTime[DateTime.Size], cell: years)
{
    dateTime[DateTime.Year] += DateTime: years;
}

//
stock void: DateTime.AddMonths(DateTime: dateTime[DateTime.Size], cell: months)
{
    while ((cell: dateTime[DateTime.Month] + months) > 12)
    {
        months -= 12;
        DateTime.AddYears(dateTime, 1);
    }
    while ((cell: dateTime[DateTime.Month] + months) < 1)
    {
        DateTime.AddYears(dateTime, -1);
        months += 12;
    }
    dateTime[DateTime.Month] += DateTime: months;
}

//
stock void: DateTime.AddDays(DateTime: dateTime[DateTime.Size], cell: days)
{
    while ((cell: dateTime[DateTime.Day] + days) > 
        DateTime.GetNumberOfDays(cell: dateTime[DateTime.Year], cell: dateTime[DateTime.Month]))
    {
        days -= DateTime.GetNumberOfDays(cell: dateTime[DateTime.Year], cell: dateTime[DateTime.Month]);
        DateTime.AddMonths(dateTime, 1);
    }
    while ((cell: dateTime[DateTime.Day] + days) < 1)
    {
        DateTime.AddMonths(dateTime, -1);
        days += DateTime.GetNumberOfDays(cell: dateTime[DateTime.Year], cell: dateTime[DateTime.Month]);
    }
    dateTime[DateTime.Day] += DateTime: days;
}

//
stock void: DateTime.AddHours(DateTime: dateTime[DateTime.Size], cell: hours)
{
    while ((cell: dateTime[DateTime.Hour] + hours) > 23)
    {
        hours -= 24;
        DateTime.AddDays(dateTime, 1);
    }
    while ((cell: dateTime[DateTime.Hour] + hours) < 0)
    {
        DateTime.AddDays(dateTime, -1);
        hours += 24;
    }
    dateTime[DateTime.Hour] += DateTime: hours;
}

//
stock void: DateTime.AddMinutes(DateTime: dateTime[DateTime.Size], cell: minutes)
{
    while ((cell: dateTime[DateTime.Minute] + minutes) > 59)
    {
        minutes -= 60;
        DateTime.AddHours(dateTime, 1);
    }
    while ((cell: dateTime[DateTime.Minute] + minutes) < 0)
    {
        DateTime.AddHours(dateTime, -1);
        minutes += 60;
    }
    dateTime[DateTime.Minute] += DateTime: minutes;
}

//
stock void: DateTime.AddSeconds(DateTime: dateTime[DateTime.Size], cell: seconds)
{
    while ((cell: dateTime[DateTime.Second] + seconds) > 59)
    {
        seconds -= 60;
        DateTime.AddMinutes(dateTime, 1);
    }
    while ((cell: dateTime[DateTime.Second] + seconds) < 0)
    {
        DateTime.AddMinutes(dateTime, -1);
        seconds += 60;
    }
    dateTime[DateTime.Second] += DateTime: seconds;
}

// The following code depends on sscanf
#if defined sscanf

//
stock DateTime: DateTime.ParseDate(const cell: dateString[], 
    DateFormat: dateFormat = DEFAULT_DATE_FORMAT,
    cell: dateSeparator = DEFAULT_DATE_SEPARATOR)
{
    new cell: v1; 
    new cell: v2; 
    new cell: v3;
    new cell: fmat[16];
    new DateTime: dateTime[DateTime.Size];

    format(fmat, sizeof(fmat), "p<%c>iii", dateSeparator);

    if (sscanf(dateString, fmat, v1, v2, v3))
        return DateTime.NewDate();

    switch (dateFormat)
    {
        case DateFormat.BigEndian:
        {
            dateTime = DateTime.NewDate(v1, v2, v3);
        }
        case DateFormat.LittleEndian:
        {
            dateTime = DateTime.NewDate(v3, v2, v1);
        }
        case DateFormat.MiddleEndian:
        {
            dateTime = DateTime.NewDate(v3, v1, v2);
        }
    }
    return dateTime;
}

//
stock DateTime: DateTime.ParseTime(const cell: timeString[], 
    TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, 
    cell: timeSeparator = DEFAULT_TIME_SEPARATOR)
{
    new cell: hour;
    new cell: minute; 
    new cell: second;
    new cell: fmat[16];
    new DateTime: dateTime[DateTime.Size];

    switch (timeFormat)
    {
        case TimeFormat.H24:
        {
            format(fmat, sizeof(fmat), "p<%c>iiI(0)", timeSeparator);

            if (sscanf(timeString, fmat, hour, minute, second))
                return DateTime.NewTime();
            
            dateTime = DateTime.NewTime(hour, minute, second);
        }
        case TimeFormat.H12:
        {
            new cell: amPm[TIME_AM_PM_LEN];
            format(fmat, sizeof(fmat), "p<%c>iiip< >s[%d]", timeSeparator, TIME_AM_PM_LEN);

            if (sscanf(timeString, fmat, hour, minute, second, amPm))
            {
                format(fmat, sizeof(fmat), "p<%c>iip< >s[%d]", timeSeparator, TIME_AM_PM_LEN);

                if (sscanf(timeString, fmat, hour, minute, amPm))
                    return DateTime.NewTime();
            }
            
            if (strlen(amPm) == 0)
                return DateTime.NewTime();
            
            if (!strcmp(amPm, TIME_AM, true))
            {
                if (hour == 12)
                    hour = 0;
            }
            else if (!strcmp(amPm, TIME_PM, true))
            {
                if (hour != 12)
                    hour += 12;
            }
            else
                return DateTime.NewTime();

            dateTime = DateTime.NewTime(hour, minute, second);
        }
    }
    return dateTime;
}

//
stock DateTime: DateTime.Parse(const cell: dateTimeString[],
    DateFormat: dateFormat = DEFAULT_DATE_FORMAT, 
    TimeFormat: timeFormat = DEFAULT_TIME_FORMAT,
    cell: dateSeparator = DEFAULT_DATE_SEPARATOR, 
    cell: timeSeparator = DEFAULT_TIME_SEPARATOR)
{
    new cell: dateString[32];
    new cell: timeString[32];
    new DateTime: date[DateTime.Size];
    new DateTime: time[DateTime.Size];
    new DateTime: dateTime[DateTime.Size];

    if (sscanf(dateTimeString, "p< >s[32]p<(>s[32]", dateString, timeString)) // p<?> to avoid losing AM/PM in the time string
    {
        return DateTime.New();
    }

    date = DateTime.ParseDate(dateString, dateFormat, dateSeparator);
    time = DateTime.ParseTime(timeString, timeFormat, timeSeparator);

    dateTime = DateTime.New(
        cell: date[DateTime.Year],
        cell: date[DateTime.Month],
        cell: date[DateTime.Day],
        cell: time[DateTime.Hour],
        cell: time[DateTime.Minute],
        cell: time[DateTime.Second]
    );
    return dateTime;
}

#else

stock DateTime: DateTime.ParseDate(const cell: dateString[], 
    DateFormat: dateFormat = DEFAULT_DATE_FORMAT,
    cell: dateSeparator = DEFAULT_DATE_SEPARATOR)
{
    #pragma unused dateString
    #pragma unused dateFormat
    #pragma unused dateSeparator
    printf("Warning: The function 'sscanf' was not found. DateTime.ParseDate() depends on sscanf.");
    return DateTime.NewDate();
}

stock DateTime: DateTime.ParseTime(const cell: timeString[], 
    TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, 
    cell: timeSeparator = DEFAULT_TIME_SEPARATOR)
{
    #pragma unused timeString
    #pragma unused timeFormat
    #pragma unused timeSeparator
    printf("Warning: The function 'sscanf' was not found. DateTime.ParseTime() depends on sscanf.");
    return DateTime.NewTime();
}

stock DateTime: DateTime.Parse(const cell: dateTimeString[],
    DateFormat: dateFormat = DEFAULT_DATE_FORMAT, 
    TimeFormat: timeFormat = DEFAULT_TIME_FORMAT,
    cell: dateSeparator = DEFAULT_DATE_SEPARATOR, 
    cell: timeSeparator = DEFAULT_TIME_SEPARATOR)
{
    #pragma unused dateTimeString
    #pragma unused dateFormat
    #pragma unused timeFormat
    #pragma unused dateSeparator
    #pragma unused timeSeparator
    printf("Warning: The function 'sscanf' was not found. DateTime.Parse() depends on sscanf.");
    return DateTime.New();
}

#endif // defined sscanf

//
stock cell: DateTime.ToDateString(const DateTime: dateTime[DateTime.Size], 
    DateFormat: dateFormat = DEFAULT_DATE_FORMAT, 
    cell: dateSeparator = DEFAULT_DATE_SEPARATOR)
{
     
    new cell: year = cell: dateTime[DateTime.Year];
    new cell: month = cell: dateTime[DateTime.Month];
    new cell: day = cell: dateTime[DateTime.Day];
    new cell: string[12];

    switch(dateFormat)
    {
        case DateFormat.BigEndian:
        {
            format(
                string, 
                sizeof(string), 
                "%04d%c%02d%c%02d", 
                year,
                dateSeparator,
                month,
                dateSeparator,
                day
            );
        }
        case DateFormat.LittleEndian:
        {
            format(
                string, 
                sizeof(string), 
                "%02d%c%02d%c%04d", 
                day,
                dateSeparator,
                month,
                dateSeparator,
                year
            );
        }
        case DateFormat.MiddleEndian:
        {
            format(
                string, 
                sizeof(string), 
                "%02d%c%02d%c%04d", 
                month,
                dateSeparator,
                day,
                dateSeparator,
                year
            );
        }
    }
    return string;
}

//
stock cell: DateTime.ToTimeString(const DateTime: dateTime[DateTime.Size], 
    TimeFormat: timeFormat = DEFAULT_TIME_FORMAT, 
    cell: timeSeparator = DEFAULT_TIME_SEPARATOR)
{
    new cell: hour = cell: dateTime[DateTime.Hour];
    new cell: minute = cell: dateTime[DateTime.Minute];
    new cell: second = cell: dateTime[DateTime.Second];
    new cell: string[12];
    
    switch(timeFormat)
    {
        case TimeFormat.H24:
        {
            format(
                string, 
                sizeof(string), 
                "%02d%c%02d%c%02d", 
                hour,
                timeSeparator,
                minute,
                timeSeparator,
                second
            );
        }
        case TimeFormat.H12:
        {
            new cell: newHour = hour;
            new cell: amPm[TIME_AM_PM_LEN];

            format(amPm, sizeof(amPm), TIME_AM);
            
            if (hour == 0)
                newHour = 12;
                
            else if (hour == 12)
            {
                format(amPm, sizeof(amPm), TIME_PM);
            }
            else if (hour > 12)
            {
                newHour = hour - 12;
                format(amPm, sizeof(amPm), TIME_PM);
            }

            format(
                string, 
                sizeof(string), 
                "%d%c%02d%c%02d %s", 
                newHour,
                timeSeparator,
                minute,
                timeSeparator,
                second,
                amPm
            );
        }
    }
    return string;
}

//
stock cell: DateTime.ToString(const DateTime: dateTime[DateTime.Size], 
    DateFormat: dateFormat = DEFAULT_DATE_FORMAT, 
    TimeFormat: timeFormat = DEFAULT_TIME_FORMAT,
    cell: dateSeparator = DEFAULT_DATE_SEPARATOR, 
    cell: timeSeparator = DEFAULT_TIME_SEPARATOR)
{
    new cell: string[26];
    strcat(string, DateTime.ToDateString(dateTime, dateFormat, dateSeparator));
    strcat(string, " ");
    strcat(string, DateTime.ToTimeString(dateTime, timeFormat, timeSeparator));
    return string;
}