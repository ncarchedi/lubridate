\name{ymd_hms}
\alias{dmy_h}
\alias{dmy_hm}
\alias{dmy_hms}
\alias{mdy_h}
\alias{mdy_hm}
\alias{mdy_hms}
\alias{ydm_h}
\alias{ydm_hm}
\alias{ydm_hms}
\alias{ymd_h}
\alias{ymd_hm}
\alias{ymd_hms}
\title{Parse dates that have hours, minutes, or seconds elements.}
\usage{
  ymd_hms(..., quiet = FALSE, tz = "UTC",
    locale = Sys.getlocale("LC_TIME"), truncated = 0)
}
\arguments{
  \item{...}{a character vector of dates in year, month,
  day, hour, minute, second format}

  \item{quiet}{logical. When TRUE function evalueates
  without displaying customary messages.}

  \item{tz}{a character string that specifies which time
  zone to parse the date with. The string must be a time
  zone that is recognized by the user's OS.}

  \item{locale}{locale to be used, see \link{locales}. On
  linux systems you can use \code{system("locale -a")} to
  list all the installed locales.}

  \item{truncated}{integer, indicating how many formats can
  be missing. See details.}
}
\value{
  a vector of POSIXct date-time objects
}
\description{
  Transform dates stored as character or numeric vectors to
  POSIXct objects. ymd_hms family of functions recognize
  all non-alphanumeric separators (with the exception of
  "." if \code{frac = TRUE}) and correctly handle
  heterogeneous date-time representations. For more
  flexibility in treatment of heterogeneous formats, see
  low level parser \code{\link{parse_date_time}}.
}
\details{
  ymd_hms() functions automatically assigns the Universal
  Coordinated Time Zone (UTC) to the parsed date. This time
  zone can be changed with \code{\link{force_tz}}.

  The most common type of irregularity in date-time data is
  the truncation due to rounding or unavailability of the
  time stamp. If \code{truncated} parameter is non-zero
  \code{ymd_hms} functions also check for truncated
  formats. For example \code{ymd_hms} with \code{truncated
  = 3} will also parse incomplete dates like
  \code{2012-06-01 12:23}, \code{2012-06-01 12} and
  \code{2012-06-01}. NOTE: \code{ymd} family of functions
  are based on \code{strptime} which currently fails to
  parse \code{\%y-\%m} formats.

  As of version 1.3.0, lubridate's parse functions no
  longer return a message that displays which format they
  used to parse their input. You can change this by setting
  the \code{lubridate.verbose} option to true with
  \code{options(lubridate.verbose = TRUE)}.
}
\examples{
x <- c("2010-04-14-04-35-59", "2010-04-01-12-00-00")
ymd_hms(x)
# [1] "2010-04-14 04:35:59 UTC" "2010-04-01 12:00:00 UTC"
x <- c("2011-12-31 12:59:59", "2010-01-01 12:00:00")
ymd_hms(x)
# [1] "2011-12-31 12:59:59 UTC" "2010-01-01 12:00:00 UTC"


## ** heterogenuous formats **
x <- c(20100101120101, "2009-01-02 12-01-02", "2009.01.03 12:01:03",
       "2009-1-4 12-1-4",
       "2009-1, 5 12:1, 5",
       "200901-08 1201-08",
       "2009 arbitrary 1 non-decimal 6 chars 12 in between 1 !!! 6",
       "OR collapsed formats: 20090107 120107 (as long as prefixed with zeros)",
       "Automatic wday, Thu, detection, 10-01-10 10:01:10 and p format: AM",
       "Created on 10-01-11 at 10:01:11 PM")
ymd_hms(x)

## ** fractional seconds **
op <- options(digits.secs=3)
dmy_hms("20/2/06 11:16:16.683")
## "2006-02-20 11:16:16.683 UTC"
options(op)

## ** different formats for ISO8601 timezone offset **
ymd_hms(c("2013-01-24 19:39:07.880-0600",
"2013-01-24 19:39:07.880", "2013-01-24 19:39:07.880-06:00",
"2013-01-24 19:39:07.880-06", "2013-01-24 19:39:07.880Z"))

## ** internationalization **
\dontrun{
x_RO <- "Ma 2012 august 14 11:28:30 "
ymd_hms(x_RO, locale = "ro_RO.utf8")
}

## ** truncated time-dates **
x <- c("2011-12-31 12:59:59", "2010-01-01 12:11", "2010-01-01 12", "2010-01-01")
ymd_hms(x, truncated = 3)
## [1] "2011-12-31 12:59:59 UTC" "2010-01-01 12:11:00 UTC"
## [3] "2010-01-01 12:00:00 UTC" "2010-01-01 00:00:00 UTC"
x <- c("2011-12-31 12:59", "2010-01-01 12", "2010-01-01")
ymd_hm(x, truncated = 2)
## [1] "2011-12-31 12:59:00 UTC" "2010-01-01 12:00:00 UTC"
## [3] "2010-01-01 00:00:00 UTC"
## ** What lubridate might not handle **
## Extremely weird cases when one of the separators is "" and some of the
## formats are not in double digits might not be parsed correctly:
\dontrun{
ymd_hm("20100201 07-01", "20100201 07-1", "20100201 7-01")}
## "2010-02-01 07:01:00 UTC" "2010-02-01 07:01:00 UTC"   NA
}
\seealso{
  \code{\link{ymd}}, \code{\link{hms}}.
  \code{\link{parse_date_time}} for underlying mechanism.
}
\keyword{POSIXt}
\keyword{parse}

