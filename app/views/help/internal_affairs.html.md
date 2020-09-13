<% @title = "Internal Affairs" %>
<% @subheadline = "Boston Police Department (BPD) Internal Affairs Division records" %>

## Overview
We present Internal Affairs Division (IAD) cases aggregated from three sources:

- [2010 to 2020 Allegations](/pages/help#allegations_2010_to_202)
- [2001 to 2011 IA Data](/pages/help#bpd_ia_data_2001_2011)
- [2014 Officer IA Log](/pages/help#2014_officer_ia_log)

These cases include both _Citizen Complaints_, where a member of the community files a complaint regarding the conduct of an officer or civilian employee of the BPD, and _Internal Investigations_. A case is identified by a unique number e.g. _IAD2019-0412_. A given case may accuse one-or-more employees, each with one-or-more allegations. A finding is made by IAD for each allegation against each officer.

For the vast majority of cases, we only have the general nature of the allegations e.g. _Neg.Duty/Unreasonable Judge_. For a subset of the cases from 2014, we also have prose summaries.

### Caveats

For 2010 to 2020, we only have records with the following allegations: Conduct Unbecoming, Neg.Duty/Unreasonable Judge, Respectful Treatment, Self Identification, and Use of Force. [See this Twitter thread](https://twitter.com/nathan_story/status/1304446879665729537).

With the exception of the records from the [2014 Officer IA Log](/pages/help#2014_officer_ia_log) file, we do not have summaries of the alleged conduct; we just have the high-level allegation e.g. "Conduct Unbecoming"

We link an allegation to an officer using the officer's name. Our algorithm for matching records will not make the link if the name is ambiguous (i.e. if two officers share the same name), however, it is possible a mis-link could happen.

Conversely, it is possible we have an allegation against an officer in our database, but it does not appear on the officer's page (i.e. it was not linked). You may wish to do a more thorough search against the [Complaints (Internal Affairs) Data Table](/complaints), which does contain all cases in our database.

### How to Access this Data

We make IAD data available in the following ways:

- [Officers & Employees Data Table](/officers) click through on an employee to show all information we hold regarding them, including IAD data
- [Complaints (Internal Affairs) Data Table](/complaints) sort, filter, and explore interactively
- [Complaints - Officers Data Export](/exports#complaints_officers) download a spreadsheet of all IAD data

## Findings

The IAD determines a finding for each allegation that makes up an Internal Investigation or Citizen Complaint. If we do not know the finding that was made for an allegation, we show <span class="text-muted font-italic">N/A</span> (Not Available) instead. Otherwise, one of the findings below will be shown:

<table class="table">
  <caption>
    Copied verbatim from <a href="https://www.boston.gov/sites/default/files/file/document_files/2016/08/co-op_annual_report_final_2015_tcm3-53522.pdf#page=11">Community Ombudsman Oversight Panel. <i>Annual Report 2015</i>, p. 11</a>
  </caption>
  <thead>
    <tr>
      <th>Finding</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Sustained</th>
      <td>The investigation revealed, by a preponderance of the evidence, that the conduct alleged in the
complaint occurred. If it is a criminal case, it is presented to proper prosecuting authorities.</td>
    </tr>
    <tr>
      <th>Exonerated</th>
      <td>The investigation revealed that the conduct alleged in the complaint did occur, but the investigator
determined that said conduct was reasonable, lawful, and proper.</td>
    </tr>
    <tr>
      <th class="text-nowrap">Not Sustained</th>
      <td>There was insufficient evidence to prove or disprove, by a preponderance of the evidence, that the
conduct alleged in the complaint occurred.</td>
    </tr>
    <tr>
      <th>Unfounded</th>
      <td>The investigation revealed that the allegations in the complaint did not occur.</td>
    </tr>
    <tr>
      <th>Pending</th>
      <td>The complaint is currently under investigation.</td>
    </tr>
  </tbody>
</table>

<h2 id="ia_score">IA Score</h2>
We calculate a score from 0 - 5 that indicates the severity of the Internal Affairs Division cases opened against an officer. This score is defined and calculated by The Woke Windows Project. The algorithm which calculates the score and the classification of allegations was invented by us, and is open to change.

<table class="table">
  <thead>
    <tr>
      <th>IA&nbsp;Score</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>5</td>
      <td>Most Concerning. One serious allegation sustained or five concerning allegations sustained across unique cases</td>
    </tr>
    <tr>
      <td>4</td>
      <td>Very Concerning. Two concerning allegations sustained across unique cases or one sustained <i>Use of Force</i> finding</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Concerning. One concerning allegation sustained</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Less Concerning. One less-concerning allegation sustained or five-or-more cases regardless of finding</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Least Concern. Two-or-more cases regardless of finding</td>
    </tr>
    <tr>
      <td>0</td>
      <td>Not Concerning. One or zero cases, none with a sustained finding</td>
    </tr>
  </tbody>
</table>

<table class="table">
  <thead>
    <tr>
      <th colspan="2">Classification of Allegations</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Serious</th>
      <td>Violation of Criminal Law, Conformance to Laws</td>
    </tr>
    <tr>
      <th>Concerning</th>
      <td>
        Neg.Duty/Unreasonable Judge, Respectful Treatment, Conduct Unbecoming, Use of Force, Untruthfulness, Drug Test, Dir./Orders, Self Identification, Directives/Orders, Abuse of Process, Securing and Maintenance of Firearm, Untruthfulness in Department Report, Investigation of Use Of Force
      </td>
    </tr>
    <tr>
      <th>Less Concerning</th>
      <td><i>All other allegations</i></td>
    </tr>
  </tbody>
</table>

## External Links

- [Community Ombudsman Oversight Panel](https://www.boston.gov/departments/law/community-ombudsman-oversight-panel) publications and reports written by the panel that reviews appeals of citizen complaints
- [Within the Boston Police Department, complaints against officers are rarely confirmed or result in punishment. _Boston Globe_](https://www.bostonglobe.com/2020/07/18/metro/within-boston-police-department-complaints-against-officers-are-rarely-confirmed-or-result-punishment/) 2020 article analyzing IAD records
- [7Investigates: Records show Boston police investigations into civilian complaints take years to complete. _WHDH_](https://whdh.com/news/7investigates-records-show-boston-police-investigations-into-civilian-complaints-take-years-to-complete/) 2020 piece looking at citizen complaints
