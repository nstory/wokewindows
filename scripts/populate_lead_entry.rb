ENTRIES = [
  [10393, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [11891, "Alleged Forgery/Uttering. Reported to BPD IAD & State Ethics Commission."],
  [120929, "OUI-Serious Bodily Injury. SCDAO investigation/prosecution on-going. Incident: Jan. 1, 2018. Special ADA Greer Spatz."],
  [12282, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [148253, "Witness intimidation, False Report, CORI Violation, Forgery, Uttering. SCDAO investigation/prosecution on-going. Incident 03/01/2019."],
  [8947, "Open BPD Internal Affairs investigations. Boston Globe 06/24/2020"],
  [12015, "Receiving stolen merchandise. SCDAO investigation/prosecution on-going."],
  [9726, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [12202, "AB (2 counts), AB to Intimidate, Use without Authority. Aqcuited of Civil Rights Violation. 2018 SCDAO investigation/prosecution."],
  [9732, "BPD internal investigation (conformance to laws). Retired. Source: Boston Globe Public Records Request."],
  [106710, "Assault with a dangerous weapon, carrying a firearm while intoxicated. SCDAO investigation/prosecution. Resolved in Veteran's Court. Incident 12/11/2013. Also, Sustained BPD internal investigation."],
  [102951, "Misleading Investigators. SCDAO investigation/prosecution on-going."],
  [148270, "ABDW Family Member. SCDAO investigation/prosecution on-going. Incident 04/19/2020."],
  [136936, "Resigned during the pendancy of a 2017 BPD internal investigation."],
  [10273, "Internal Affairs investigation alleged corruption. Source: Commonwealth Magazine 09/20/2020."],
  [9370, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [86180, "Alleged racial slurs (09/13/2019 noise complaint/Roxbury Prep students). SCDAO investigation on-going."],
  [10286, "BPD internal investigation (conformance to laws). Retired when charges pending. Source: Boston Globe 09/23/2020"],
  [103766, "BPD internal investigation (conformance to laws). Separation Agreement. Source: Boston Globe Public Records Request."],
  [10172, "BPD internal investigation (conformance to laws). Resigned. Source: Boston Globe Public Records Request."],
  [10603, "Improper firearm storage. SCDAO investigation/prosecution. Agreed-upon plea. Incident: 08/6/2015."],
  [11120, "Motion To Suppress (Judge Mary Ames Suffolk Superior Court decision)."],
  [11906, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [12132, "Larceny, money laundering. Joint investigation AGO/SCDAO/BPD Anti-Corruption. GJ Indictment 10/12/2017. CWOF - Dismissed."],
  [8227, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [10294, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [81488, "Access device fraud. USAO investigation/prosecution. Guilty plea 08/09/2016."],
  [11126, "Aggravated Rape of Child, Rape of Child. SCDAO investigation/prosecution on-going."],
  [10970, "Alleged ABDW, Witness Intimidation, Perjury. SCDAO investigation on-going."],
  [11530, "USAO investigation/prosecution. Guilty plea. Sentence on 01/28/2016."],
  [103868, "Witness intimidation. SCDAO investigation/prosectution on-going."],
  [135938, "BPD internal investigation (conformance to laws). Resigned. Source: Boston Globe Public Records Request."],
  [9807, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [10093, "Conspiracy/embezzlement: Time & attendance. USAO prosecution on-going."],
  [10327, "BPD internal investigation (conformance to laws). Retired when charges pending. Source: Boston Globe 09/23/2020"],
  [8195, "Larceny: Time & attendance/overtime. SCDAO investigation/prosecution. CWOF - Dismissed."],
]

ENTRIES.each do |emp_no, lead_entry|
  o = Officer.find_by(employee_id: emp_no)
  o.lead_entry = lead_entry
  o.save!
end
