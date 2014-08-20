Background
----------

Pulsar (Puppet Unix Lockdown Security Analysis Report) was developed with the
goal of having a tool that could report on and lockdown a Unix machine according
to a security baseline. It is based on CIS and other frameworks. It is also based
on an earlier security audit script I wrote which ran as a shell script (lunar).

It was developed with puppet in mind as a lot of the customers I deal with use
Puppet as a configuration management tool. As I also wanted and need an audit
tool I could run from the command lime (much like lunar), it differs a little
from a standard Puppet module in that it can produce a report without making
changes (much like a Puppet noop run, except that a audit report is generated).

In order to use Puppet as an audit/report custom facts have been created to
determine the current configuration and report whether those configurations
meet the recommended configuration. As the various tests included in the report
come with included documentation a wrapper script has been included which runs
Puppet and cleans up the output so that it is suitable for auditing/reporting
purposes.

This was also driven out of a desire to create abstracted Puppet classes that
were easier and faster to use than the standard ones. Although Puppet has the
obvious benefit of being a commonly used configuration framework, in a lot of
cases I find it far less overhead, system and time wise, to use other tools.
Having said this there are things I like about Puppet, including the change in
approach to IT delivery processes and thinking it has inspired by its wide
adoptance.

License
-------

This software is licensed as CC-BA (Creative Commons By Attrbution)

http://creativecommons.org/licenses/by/4.0/legalcode

Features
--------

- Based on CIS and other security frameworks
- Support for Mac OS X
  - 10.6 or later
- Support for Linux
  - Centos, RHEL, Debian, Ubuntu
- Support for Solaris
  - 2.6 to 11
- Support for AIX
  - 4.x to 6.x
  - Not finished
  - Requires testing
- Includes reporting and lockdown modes
  - Reporting is working well
  - Lockdown needs more testing
  - Recommed using for reporting only until I remove this note
- Includes a wrapper script to run puppet and exclude debug/unwanted output
- Includes a script to create symlink based facts required for operation
- Includes a number of wrapper classes that make coding/using Puppet quicker and easier
- Includes abstracted classes where keywords can be used rather than files speeding up development

Status
------

- Reporting has been reasonably well tested on Mac OS X, Linux and Solaris
  - AIX support is not completed
  - Testing is required on AIX and FreeBSD
- Lockdown testing is in progress
  - Recommed using for reporting only until I remove this note
  - As part of the lockdown mode I hope to have a backup function like I implemented with lunar
- Components nearing completion
  - Xinetd service support
  - Improved file editing module
    - Supports configuration files with stanzas, e.g. [Server]
- Things to add
  - A scoring system like lunar
  - PDF output for report


Documentation
-------------

[Introduction](https://github.com/lateralblast/pulsar/wiki/1.-Introduction)

[Installation](https://github.com/lateralblast/pulsar/wiki/2.-Installation)

[Usage](https://github.com/lateralblast/pulsar/wiki/3.-Usage)

[Examples](https://github.com/lateralblast/pulsar/wiki/4.-Examples)
- [OSX](https://github.com/lateralblast/pulsar/wiki/4.1.-OSX)
- [Linux](https://github.com/lateralblast/pulsar/wiki/4.2.-Linux)
- [Solaris](https://github.com/lateralblast/pulsar/wiki/4.3.-Solaris)
- [AIX](https://github.com/lateralblast/pulsar/wiki/4.4.-AIX)

[Challenges](https://github.com/lateralblast/pulsar/wiki/5.-Challenges)


