<% @title = "Traffic Citations" %>
<% @subheadline = "Traffic tickets issued by the Boston Police Department (BPD)" %>

**Warning: there are questions regarding the completeness of these data**

## Overview
Citations issued for speeding, marked lanes violation, and a variety of other infractions are made using a standard form provided by the [Massachusetts Department of Transporation](https://www.mass.gov/orgs/massachusetts-department-of-transportation) (MassDOT) called the Massachusetts Uniform Citation.

<%= image_tag "ma_uniform_citation.png", alt: "Massachusetts Uniform Citation", class: "d-block" %>
[Download a high-resolution PDF of this form](https://wokewindows-data.s3.amazonaws.com/MA_Uniform_Citation 2012_sub7_13_12.pdf)

When an officer issues a citation, a copy of that citation is sent to MassDOT where it is scanned and entered into a database. The traffic citations we display on StateReference Window come from a [public records request](/data_sources/2011_2020_citations) to MassDOT.

### Caveats

- records are for the years 2011 - 2020
- there are questions regarding the completeness of these records (whether this is in-fact all citations issued in this time period); we have observed a variance in the total number of citations between datasets provided by MassDOT

### How to Access these Data
We make traffic citation data available in the following ways:

- [Officers & Employees Data Table](/officers) click through on an employee to show all information we hold regarding them, including traffic citations they issued
- [Traffic Citations Data Table](/citations) sort, filter, and explore interactively
- [Traffic Citations Data Export](/exports#citations) download a spreadsheet of all traffic citations in our database
- [2011 - 2020 Traffic Tickets](/data_sources/2011_2020_citations) download the files provided by MassDOT
- [nstory/boston\_pd\_citations](https://github.com/nstory/boston_pd_citations) GitHub repository matching traffic citation to officer names; contains links to spreadsheets of all traffic citations
