<% @title = "Appeals Database" %>
<% @subheadline = "Decisions made by the Public Records Division of the Secretary of the Commonwealth of Massachusetts" %>

## Overview
We've collected (or "scraped") Massachusetts public records appeals and made them available as a [searchable database on StateReference Window](/appeals).

**[Read the blog post to learn more](https://blog.wokewindows.org/2021/03/28/appeals-database.html)**

## Search Syntax
By default, we search the text of any determinations attached to an appeal and the name of the Custodian to whom the request was submitted.

Combine `AND` and `OR` operators:
[`"internal affairs" AND ("boston police" OR "cambridge police")`](/appeals?q="internal+affairs"+AND+%28"boston+police"+OR+"cambridge+police"%29)

Appeals where the Custodian field contains "Salem":
[`custodian ~ salem`](/appeals?q=custodian+~+salem)

Appeals where the Response Provided Date is set:
[`set? resp_prov_date`](/appeals?q=set%3F+resp_prov_date)

Appeals submitted by news organizations seeking internal affairs records from law enforcement agencies and limited to those appeals where a response was eventually provided by the agency:
[`("boston globe" OR wbur OR wgbh OR wcvb OR "boston herald" OR masslive OR "boston magazine" OR "commonwealth magazine" OR "Patriot Ledger") AND set? resp_prov_date AND "electronic copy of this response" AND (police OR sheriff OR correction) AND ("internal affairs" OR disciplin OR "internal invest" OR "citizen complaint")`](/appeals?q=%28"boston+globe"+OR+wbur+OR+wgbh+OR+wcvb+OR+"boston+herald"+OR+masslive+OR+"boston+magazine"+OR+"commonwealth+magazine"+OR+"Patriot+Ledger"%29+AND+set%3F+resp_prov_date+AND+"electronic+copy+of+this+response"+AND+%28police+OR+sheriff+OR+correction%29+AND+%28"internal+affairs"+OR+disciplin+OR+"internal+invest"+OR+"citizen+complaint"%29)

## See Also
* [Public Records Appeals Database](https://blog.wokewindows.org/2021/03/28/appeals-database.html) &mdash; blog post about this feature
* [nstory/public\_records\_division](https://github.com/nstory/public_records_division) &mdash; Scraper for the Massachusetts Public Records Appeals Database
* [Appeals Tracking System: Search for an appeal](https://www.sec.state.ma.us/AppealsWeb/AppealsStatus.aspx) &mdash; the state’s interface for searching appeals
