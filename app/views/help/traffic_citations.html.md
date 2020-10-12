<% @title = "Traffic Citations" %>
<% @subheadline = "Traffic tickets issued by the Boston Police Department (BPD)" %>

**Warning: there are questions regarding the completeness of these data**

## Overview
Citations issued for speeding, marked lanes violation, and a variety of other infractions are made using a standard form provided by the [Massachusetts Department of Transporation](https://www.mass.gov/orgs/massachusetts-department-of-transportation) (MassDOT) called the Massachusetts Uniform Citation.

<%= image_tag "ma_uniform_citation.png", alt: "Massachusetts Uniform Citation", class: "d-block" %>
[Download a high-resolution PDF of this form](https://wokewindows-data.s3.amazonaws.com/MA_Uniform_Citation 2012_sub7_13_12.pdf)

When an officer issues a citation, a copy of that citation is sent to MassDOT where it is scanned and entered into a database. The traffic citations we display on Woke Windows come from a [public records request](/data_sources/2019_tickets) to MassDOT.

### Caveats

- we only have records for the year 2019
- there are questions regarding the completeness of these records (whether this is in-fact all citations issued in 2019); any statistical analysis that relies on that assumption is suspect

### How to Access these Data
We make traffic citation data available in the following ways:

- [Officers & Employees Data Table](/officers) click through on an employee to show all information we hold regarding them, including traffic citations they issued
- [Traffic Citations Data Table](/citations) sort, filter, and explore interactively
- [Traffic Citations Data Export](/exports#citations) download a spreadsheet of all traffic citations in our database
- [2019 Traffic Tickets](/data_sources/2019_tickets) download the files provided by MassDOT; these include citations issued by all law enforcement in Massachusetts, not just Boston Police
