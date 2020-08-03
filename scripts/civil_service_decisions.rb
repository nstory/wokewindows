require "pry"

TXT = """
Boston Police Department Hair Drug Test Appeals - Related Superior Court Decision 3/11/19	https://www.mass.gov/doc/boston-police-department-hair-drug-test-appeals-related-superior-court-decision-31119/download
Brandao, Emanuel v. Boston Police Department 7/18/19	https://www.mass.gov/doc/brandao-emanuel-v-boston-police-department-71819/download
Brandao, Emmanuel v. Boston Police Department - Related Superior Court Decision 5/1/20	https://www.mass.gov/doc/brandao-emmanuel-v-boston-police-department-related-superior-court-decision-5120/download
James, Brenda v. Boston Police Department - Related Superior Court Decision 12/22/17	https://www.mass.gov/doc/james-brenda-v-boston-police-department-related-superior-court-decision-122217/download
McGoldrick, Patricia v. Boston Police Department 3/30/17	https://www.mass.gov/doc/mcgoldrick-patricia-v-boston-police-department-33017/download
Merricks, Kirk v. Boston Police Department 5/10/18	https://www.mass.gov/doc/merricks-kirk-v-boston-police-department-51018/download
Alidrissi, Aaron v. Boston Police Department 1/31/19	https://www.mass.gov/doc/alidrissi-aaron-v-boston-police-department-13119/download
Barbosa, Maqueila v. Boston Police Department 10/26/17	https://www.mass.gov/doc/barbosa-maqueila-v-boston-police-department-102617/download
Carnell, Hernandez, Moccia & Robichaud v. Boston Police Department 2/27/20	https://www.mass.gov/doc/carnell-hernandez-moccia-robichaud-v-boston-police-department-22720/download
Dabene, Paul v. Boston Police Department 4/12/18	https://www.mass.gov/doc/dabene-paul-v-boston-police-department-41218/download
Daveiga, Nuias v. Boston Police Department - Related Appeals Court Decision 4/6/17	https://www.mass.gov/doc/daveiga-nuias-v-boston-police-department-related-appeals-court-decision-4617/download
Dorn, Akim v. Boston Police Department 12/20/18	https://www.mass.gov/doc/dorn-akim-v-boston-police-department-122018/download
Finklea, Keon v. Boston Police Department - Related Superior Court Decision 2/15/18	https://www.mass.gov/doc/finklea-keon-v-boston-police-department-related-superior-court-decision-21518/download
Finklea, Keon v. Boston Police Department 3/2/17	https://www.mass.gov/doc/finklea-keon-v-boston-police-department-3217/download
Gaitor, Jamaine v. Boston Police Department 5/11/17	https://www.mass.gov/doc/gaitor-jamaine-v-boston-police-department-51117/download
Gaitor, Jamaine v. Boston Police Department 6/8/17	https://www.mass.gov/doc/gaitor-jamaine-v-boston-police-department-6817/download
Gannon, Michael v. Boston Police Department - Related SJC Decision 10/30/19	https://www.mass.gov/doc/gannon-michael-v-boston-police-department-related-sjc-decision-103019/download
Gannon, Michael v. Boston Police Department - Related Superior Court Decision  3/13/17	https://www.mass.gov/doc/gannon-michael-v-boston-police-department-related-superior-court-decision-31317/download
Gateau, Keny v. Boston Police Department 2/2/17	https://www.mass.gov/doc/gateau-keny-v-boston-police-department-2217/download
Kerr, James v. Boston Police Department 1/18/18	https://www.mass.gov/doc/kerr-james-v-boston-police-department-11818/download
Lewis, Michael v. Boston Police Department 4/12/18	https://www.mass.gov/doc/lewis-michael-v-boston-police-department-41218/download
Marchionda, Michael v. Boston Police Department 8/15/19	https://www.mass.gov/doc/marchionda-michael-v-boston-police-department-81519/download
Morgan, Malik v. Boston Police Department 3/26/20	https://www.mass.gov/doc/morgan-malik-v-boston-police-department-32620/download
Nelson, Caleb v. Boston Police Department 4/11/19	https://www.mass.gov/doc/nelson-caleb-v-boston-police-department-41119/download
Owens, Michael v. Boston Police Department 1/3/18	https://www.mass.gov/doc/owens-michael-v-boston-police-department-1318/download
Qirici, Enxhi v. Boston Police Department 7/18/19	https://www.mass.gov/doc/qirici-enxhi-v-boston-police-department-71819/download
Rogers, Michelle v. Boston Police Department 6/18/20	https://www.mass.gov/doc/rogers-michelle-v-boston-police-department-61820/download
Stylien, Alex v. Boston Police Department 6/21/18	https://www.mass.gov/doc/stylien-alex-v-boston-police-department-62118/download
Sullivan, Carla v. Boston Police Department - Related Superior Court Decision 2/27/17	https://www.mass.gov/doc/sullivan-carla-v-boston-police-department-related-superior-court-decision-22717/download
Zaiter, Daniel v. Boston Police Department - Related Superior Court Decision 8/3/17	https://www.mass.gov/doc/zaiter-daniel-v-boston-police-department-related-superior-court-decision-8317-0/download
Clarke, Wayne v. Boston Police Department and Human Resources Division 11/9/17	https://www.mass.gov/doc/clarke-wayne-v-boston-police-department-and-human-resources-division-11917/download
Merced, Sixto v. Boston Police Department and Human Resources Division - Related Superior Court Decision 1/19/18	https://www.mass.gov/doc/merced-sixto-v-boston-police-department-and-human-resources-division-related-superior-court/download
Wilbanks, Sean v. Human Resources Division and Boston Police Department - Related Superior Court Decision 7/24/17	https://www.mass.gov/doc/wilbanks-sean-v-human-resources-division-and-boston-police-department-related-superior-court/download
Araujo, Jose v. Boston Police Department 7/25/13	https://www.mass.gov/doc/araujo-jose-v-boston-police-department-72513/download
Berrios, Crystal v. Boston Police Department 3/3/16	https://www.mass.gov/doc/berrios-crystal-v-boston-police-department-3316/download
Berryman, Matthew v. Boston Police Department 9/29/16	https://www.mass.gov/doc/berryman-matthew-v-boston-police-department-92916/download
Buckley, Jr., John v. Boston Police Department 6/13/13	https://www.mass.gov/doc/buckley-jr-john-v-boston-police-department-61313/download
Candreva, Ida v. Boston Police Department - Related Superior Court Decision 6/13/11	https://www.mass.gov/doc/candreva-ida-v-boston-police-department-related-superior-court-decision-61311/download
Chaves, David v. Boston Police Department - Related Superior Court Decision 2/29/212	https://www.mass.gov/doc/chaves-david-v-boston-police-department-related-superior-court-decision-229212/download
Chaves, David v. Boston Police Department - Related Superior Court Order 4/27/11	https://www.mass.gov/doc/chaves-david-v-boston-police-department-related-superior-court-order-42711/download
Chermesino, Robert v. Boston Police Department - Related Appeals Court Decision 10/25/13	https://www.mass.gov/doc/chermesino-robert-v-boston-police-department-related-appeals-court-decision-102513/download
Clark, Kelly v. Boston Police Department 6/27/13	https://www.mass.gov/doc/clark-kelly-v-boston-police-department-62713/download
Cordeiro, Jeffrey v. Boston Police Department - Related Superior Court Decision 1/31/11	https://www.mass.gov/doc/cordeiro-jeffrey-v-boston-police-department-related-superior-court-decision-13111/download
Corsetti, Marcus v. Boston Police Department 1/9/14	https://www.mass.gov/doc/corsetti-marcus-v-boston-police-department-1914/download
Crosby, Alicia v. Boston Police Department - Related Superior Court Decision 9/27/13	https://www.mass.gov/doc/crosby-alicia-v-boston-police-department-related-superior-court-decision-92713/download
Cruceta, Neysa v. Boston Police Department 4/5/12	https://www.mass.gov/doc/cruceta-neysa-v-boston-police-department-4512/download
D'Amato, Francesco v. Boston Police Department 2/24/11	https://www.mass.gov/doc/damato-francesco-v-boston-police-department-22411/download
Damas, Vladimer v. Boston Police Department 12/8/16	https://www.mass.gov/doc/damas-vladimer-v-boston-police-department-12816/download
Damas, Vladimir v. Boston Police Department 6/26/14	https://www.mass.gov/doc/damas-vladimir-v-boston-police-department-62614-0/download
DaVeiga, Nuais v. Boston Police Department 6/13/13	https://www.mass.gov/doc/daveiga-nuais-v-boston-police-department-61313/download
Daveiga, Nuias v. Boston Police Department - Related Superior Court Decision 3/1/16	https://www.mass.gov/doc/daveiga-nuias-v-boston-police-department-related-superior-court-decision-3116/download
Daveiga, Nuias v. Boston Police Department 10/2/14	https://www.mass.gov/doc/daveiga-nuias-v-boston-police-department-10214/download
Depina, Germano v. Boston Police Department 6/2/11	https://www.mass.gov/doc/depina-germano-v-boston-police-department-6211/download
Dumeus, Wigens v. Boston Police Department 3/10/11	https://www.mass.gov/doc/dumeus-wigens-v-boston-police-department-31011/download
Dunn, Christopher v. Boston Police Department 8/21/14	https://www.mass.gov/doc/dunn-christopher-v-boston-police-department-82114/download
Fitzgibbon, Daniel v. Boston Police Department - Related Superior Court Decision 3/21/13	https://www.mass.gov/doc/fitzgibbon-daniel-v-boston-police-department-related-superior-court-decision-32113/download
Gannon, Michael v. Boston Police Department 10/29/15	https://www.mass.gov/doc/gannon-michael-v-boston-police-department-102915/download
Gendrolis, Andrea v. Boston Police Department 12/1/11	https://www.mass.gov/doc/gendrolis-andrea-v-boston-police-department-12111/download
Harry, Keison v. Boston Police Department 1/27/11	https://www.mass.gov/doc/harry-keison-v-boston-police-department-12711/download
James, Vincent v. Boston Police Department 6/26/14	https://www.mass.gov/doc/james-vincent-v-boston-police-department-62614/download
Jean-Philipe, Marc-Arthur v. Boston Police Dept. 10/6/11	https://www.mass.gov/doc/jean-philipe-marc-arthur-v-boston-police-dept-10611/download
Josephs, Paula v. Boston Police Department 6/16/11	https://www.mass.gov/doc/josephs-paula-v-boston-police-department-61611/download
Kavaleski, Jill v. Boston Police Department - Related SJC Decision 11/6/12	https://www.mass.gov/doc/kavaleski-jill-v-boston-police-department-related-sjc-decision-11612/download
Kavaleski, Jill v. Boston Police Department - Related SJC Order 4/27/11	https://www.mass.gov/doc/kavaleski-jill-v-boston-police-department-related-sjc-order-42711/download
Kelly, Brian v. Boston Police Department 12/8/16	https://www.mass.gov/doc/kelly-brian-v-boston-police-department-12816/download
Lancaster, Scott v. Boston Police Department 11/12/15	https://www.mass.gov/doc/lancaster-scott-v-boston-police-department-111215/download
Lorthe, Yves v. Boston Police Department 1/8/15	https://www.mass.gov/doc/lorthe-yves-v-boston-police-department-1815/download
Lucas, Kristine v. Boston Police Department 11/1/12	https://www.mass.gov/doc/lucas-kristine-v-boston-police-department-11112/download
Lynch, Francine v. Boston Police Department 1/27/11	https://www.mass.gov/doc/lynch-francine-v-boston-police-department-12711/download
Lynch, Francine v. Boston Police Department Reconsideration 3/10/11	https://www.mass.gov/doc/lynch-francine-v-boston-police-department-reconsideration-31011/download
Monteiro, Lencol v. Boston Police Department - Related Superior Court Decision 6/30/15	https://www.mass.gov/doc/monteiro-lencol-v-boston-police-department-related-superior-court-decision-63015/download
Monteiro, Lencol v. Boston Police Department 10/2/14	https://www.mass.gov/doc/monteiro-lencol-v-boston-police-department-10214/download
Monteiro, Lencol v. Boston Police Department 10/1614	https://www.mass.gov/doc/monteiro-lencol-v-boston-police-department-101614/download
Morley, Gary v. Boston Police Department 9/29/16	https://www.mass.gov/doc/morley-gary-v-boston-police-department-92916/download
Mulligan, Andrew v. Boston Police Department 1/8/15	https://www.mass.gov/doc/mulligan-andrew-v-boston-police-department-1815/download
Murphy, Brendan v. Boston Police Department 8/22/13	https://www.mass.gov/doc/murphy-brendan-v-boston-police-department-82213/download
O'Rourke, Christopher v. Boston Police Department - Related Superior Court Decision 10/6/15	https://www.mass.gov/doc/orourke-christopher-v-boston-police-department-related-superior-court-decision-10615/download
O'Rourke, Christopher v. Boston Police Department 9/19/13	https://www.mass.gov/doc/orourke-christopher-v-boston-police-department-91913/download
O'Sullivan, David v. Boston Police Department 3/31/16	https://www.mass.gov/doc/osullivan-david-v-boston-police-department-33116/download
Ortiz, Franklin v. Boston Police Department 10/18/12	https://www.mass.gov/doc/ortiz-franklin-v-boston-police-department-101812/download
Ozias, Jean-Baptiste v. Boston Police Department 1/27/11	https://www.mass.gov/doc/ozias-jean-baptiste-v-boston-police-department-12711/download
Palmer, Renee v. Boston Police Department - Related Superior Court Decision 1/22/13	https://www.mass.gov/doc/palmer-renee-v-boston-police-department-related-superior-court-decision-12213/download
Palmer, Renee v. Boston Police Department 12/29/11	https://www.mass.gov/doc/palmer-renee-v-boston-police-department-122911/download
Perry, Brian v. Boston Police Department 9/20/12	https://www.mass.gov/doc/perry-brian-v-boston-police-department-92012/download
Pugsley, Sean v. Boston Police Department and HRD 2/18/16	https://www.mass.gov/doc/pugsley-sean-v-boston-police-department-and-hrd-21816/download
Rohlfing, Robert v. Boston Police Department 11/13/14	https://www.mass.gov/doc/rohlfing-robert-v-boston-police-department-111314/download
Rosa, Domingos v. Boston Police Department 8/21/14	https://www.mass.gov/doc/rosa-domingos-v-boston-police-department-82114/download
Rowley, Thomas v. Boston Police Department 8/8/13	https://www.mass.gov/doc/rowley-thomas-v-boston-police-department-8813/download
Savickas, Richard v. Boston Police Department-Related Superior Court Decision 9/30/11	https://www.mass.gov/doc/savickas-richard-v-boston-police-department-related-superior-court-decision-93011-0/download
Sena, Ashley v. Boston Police Department 5/1/14	https://www.mass.gov/doc/sena-ashley-v-boston-police-department-5114/download
Shackford, Michael v. Boston Police Department 7/24/14	https://www.mass.gov/doc/shackford-michael-v-boston-police-department-72414/download
Shore, Gregory v. Boston Police Department 8/9/12	https://www.mass.gov/doc/shore-gregory-v-boston-police-department-8912/download
Sostre, Lumarie v. Boston Police Department 10/17/13	https://www.mass.gov/doc/sostre-lumarie-v-boston-police-department-101713/download
Sullivan, Carla v. Boston Police Department 1/21/16	https://www.mass.gov/doc/sullivan-carla-v-boston-police-department-12116-0/download
Sullivan, Carla v. Boston Police Department 5/28/15	https://www.mass.gov/doc/sullivan-carla-v-boston-police-department-52815/download
Suppa, David v. Boston Police Department - Related Appeals Court Decision 5/27/11	https://www.mass.gov/doc/suppa-david-v-boston-police-department-related-appeals-court-decision-52711/download
Tobin, Mark v. Boston Police Department 3/17/16	https://www.mass.gov/doc/tobin-mark-v-boston-police-department-31716/download
Tran, Ciara v. Boston Police Department 3/22/12	https://www.mass.gov/doc/tran-ciara-v-boston-police-department-32212/download
Tran, Don v. Boston Police Department 7/24/14	https://www.mass.gov/doc/tran-don-v-boston-police-department-72414/download
Vetiac, Shella v. Boston Police Department 6/26/14	https://www.mass.gov/doc/vetiac-shella-v-boston-police-department-62614/download
Walker, Brian v. Boston Police Department - Related Appeals Court Decision 1/16/13	https://www.mass.gov/doc/walker-brian-v-boston-police-department-related-appeals-court-decision-11613/download
Wells, Joseph v. Boston Police Department 6/13/13	https://www.mass.gov/doc/wells-joseph-v-boston-police-department-61313/download
Wosny, Nicholas v. Boston Police Department 1/7/16	https://www.mass.gov/doc/wosny-nicholas-v-boston-police-department-1716/download
Wosny, Nicolas v. Boston Police Department 8/8/13	https://www.mass.gov/doc/wosny-nicolas-v-boston-police-department-8813/download
Zaiter, Daniel v. Boston Police Department 8/18/16	https://www.mass.gov/doc/zaiter-daniel-v-boston-police-department-81816/download
Boston Police Department Drug Test Appeals - Related Appeals Court Decision 10/7/16	https://www.mass.gov/doc/boston-police-department-drug-test-appeals-related-appeals-court-decision-10716/download
Boston Police Department Drug Test Appeals - Related Superior Court Decision 10/6/14	https://www.mass.gov/doc/boston-police-department-drug-test-appeals-related-superior-court-decision-10614/download
Boston Police Department Drug Testing Appeals 2/28/13	https://www.mass.gov/doc/boston-police-department-drug-testing-appeals-22813/download
James, Brenda v. Boston Police Department 3/31/16	https://www.mass.gov/doc/james-brenda-v-boston-police-department-33116/download
James, Brenda v. Boston Police Department 4/2/15	https://www.mass.gov/doc/james-brenda-v-boston-police-department-4215/download
Landrum, Stephen v. Boston Police Department 1/27/11	https://www.mass.gov/doc/landrum-stephen-v-boston-police-department-12711/download
Tinker, Robert v. Boston Police Department 11/3/11	https://www.mass.gov/doc/tinker-robert-v-boston-police-department-11311/download
Boston Police Department 2015 Appointment Process 9/15/16	https://www.mass.gov/doc/boston-police-department-2015-appointment-process-91516/download
Boston Police Department 2015 Appointment Process Review 7/21/16	https://www.mass.gov/doc/boston-police-department-2015-appointment-process-review-72116/download
Boston Police Department 2015 Appointment Process Review Status Update 8/4/16	https://www.mass.gov/doc/boston-police-department-2015-appointment-process-review-status-update-8416/download
Boston Police Department Investigation:  Selective Certifications 10/18/12	https://www.mass.gov/doc/boston-police-department-investigation-selective-certifications-101812/download
Boston Police Department Investigation Re: 2015 Appointment Process 6/9/16	https://www.mass.gov/doc/boston-police-department-investigation-re-2015-appointment-process-6916/download
Clarke, Wayne v. Boston Police Department and HRD 1/7/16	https://www.mass.gov/doc/clarke-wayne-v-boston-police-department-and-hrd-1716-0/download
Dorsey, Sara v. Boston Police Department 3/3/16	https://www.mass.gov/doc/dorsey-sara-v-boston-police-department-3316-0/download
Flynn, John and 8 Others v. Boston Police Department Procedural Order 5/12/11	https://www.mass.gov/doc/flynn-john-and-8-others-v-boston-police-department-procedural-order-51211/download
Gillespie, Joseph and 3 Others v. Boston Police Department 4/7/11	https://www.mass.gov/doc/gillespie-joseph-and-3-others-v-boston-police-department-4711/download
Goggin, Michael v. Boston Police Dept. & HRD 2/4/16	https://www.mass.gov/doc/goggin-michael-v-boston-police-dept-hrd-2416/download
Goggin, Michael v. Boston Police Dept. & HRD 3/17/16	https://www.mass.gov/doc/goggin-michael-v-boston-police-dept-hrd-31716/download
Grace, Edward v. Boston Police Department and HRD 4/2/15	https://www.mass.gov/doc/grace-edward-v-boston-police-department-and-hrd-4215/download
Kervin et al v. Boston Police Department and HRD 8/21/14	https://www.mass.gov/doc/kervin-et-al-v-boston-police-department-and-hrd-82114/download
McCarthy, Joel et al v. Boston Police Department 5/14/15	https://www.mass.gov/doc/mccarthy-joel-et-al-v-boston-police-department-51415/download
Merced, Sixto v. Boston Police Dept. & HRD 2/4/16	https://www.mass.gov/doc/merced-sixto-v-boston-police-dept-hrd-2416/download
Merced, Sixto v. Boston Police Dept. & HRD 3/17/16	https://www.mass.gov/doc/merced-sixto-v-boston-police-dept-hrd-31716/download
Sousa, Kenneth v. Boston Police Department and HRD 1/7/16	https://www.mass.gov/doc/sousa-kenneth-v-boston-police-department-and-hrd-1716/download
Wilbanks, Sean v. Boston Police Department and HRD 1/7/16	https://www.mass.gov/doc/wilbanks-sean-v-boston-police-department-and-hrd-1716/download
Alfred, Ulrich v. Boston Police Department 4/26/07	https://www.mass.gov/doc/alfred-ulrich-v-boston-police-department-42607/download
Allen, Anthony v. Boston Police Department 1/31/08	https://www.mass.gov/doc/allen-anthony-v-boston-police-department-13108/download
Alves, John v. Boston Police Department 7/23/09	https://www.mass.gov/doc/alves-john-v-boston-police-department-72309/download
Aponte, Carlos v. Boston Police Department 9/20/07	https://www.mass.gov/doc/aponte-carlos-v-boston-police-department-92007/download
Boutin, Jessica v. Boston Police Department 1/29/09 (Under Appeal)	https://www.mass.gov/doc/boutin-jessica-v-boston-police-department-12909-under-appeal/download
Brimley, Latarsha v. Boston Police Department 5/10/07	https://www.mass.gov/doc/brimley-latarsha-v-boston-police-department-51007/download
Candreva, Ida v. Boston Police Department 1/15/09 - Affirmed by Superior Court on 6/13/11	https://www.mass.gov/doc/candreva-ida-v-boston-police-department-11509-affirmed-by-superior-court-on-61311/download
Cawley, Kerri v. Boston Police Department - Related Superior Court Decision 7/7/07	https://www.mass.gov/doc/cawley-kerri-v-boston-police-department-related-superior-court-decision-7707/download
Cawley, Kerri v. Boston Police Department 10/22/06	https://www.mass.gov/doc/cawley-kerri-v-boston-police-department-102206/download
Cawley, Stephen v. Boston Police Department 7/24/08	https://www.mass.gov/doc/cawley-stephen-v-boston-police-department-72408/download
Centola, Richard v. Boston Police Department 10/22/06	https://www.mass.gov/doc/centola-richard-v-boston-police-department-102206/download
Chaves, David v. Boston Police Department 12/2/10	https://www.mass.gov/doc/chaves-david-v-boston-police-department-12210/download
Chermesino, Robert v. Boston Police Department 7/29/10	https://www.mass.gov/doc/chermesino-robert-v-boston-police-department-72910/download
Connelly, Thomas v. Boston Police Department 2/21/08	https://www.mass.gov/doc/connelly-thomas-v-boston-police-department-22108/download
Connolly, Sean v. Boston Police Department 12/30/10	https://www.mass.gov/doc/connolly-sean-v-boston-police-department-123010/download
Cordeiro, Jeffrey v. Boston Police Department 1/15/09 (Vacated by Superior Court on 1/31/11)	https://www.mass.gov/doc/cordeiro-jeffrey-v-boston-police-department-11509-vacated-by-superior-court-on-13111/download
Coren, Patrick v. Boston Police Department 12/30/10	https://www.mass.gov/doc/coren-patrick-v-boston-police-department-123010/download
Coutts, Kelley v. Boston Police Department - Related Superior Court Decision 6/16/10	https://www.mass.gov/doc/coutts-kelley-v-boston-police-department-related-superior-court-decision-61610/download
Coutts, Kelley v. Boston Police Department 5/7/09 (Affirmed by Superior Court on 6/16/10)	https://www.mass.gov/doc/coutts-kelley-v-boston-police-department-5709-affirmed-by-superior-court-on-61610/download
Crosby, Alicia v. Boston Police Department 6/3/10	https://www.mass.gov/doc/crosby-alicia-v-boston-police-department-6310/download
Crosby, Jennifer v. Boston Police Department 4/26/07	https://www.mass.gov/doc/crosby-jennifer-v-boston-police-department-42607/download
Croteau, Scott v. Boston Police Department 4/5/07	https://www.mass.gov/doc/croteau-scott-v-boston-police-department-4507/download
Davis, Gregory v. Boston Police Department 5/8/08	https://www.mass.gov/doc/davis-gregory-v-boston-police-department-5808/download
Driscoll, Jeremiah v. Boston Police Department 7/26/07	https://www.mass.gov/doc/driscoll-jeremiah-v-boston-police-department-72607/download
Dunn Cooper, Vera v. Boston Police Department 7/31/08	https://www.mass.gov/doc/dunn-cooper-vera-v-boston-police-department-73108/download
Escobar, Richard v. Boston Police Department 4/10/08	https://www.mass.gov/doc/escobar-richard-v-boston-police-department-41008/download
Fay, Peter v. Boston Police Department 7/17/08	https://www.mass.gov/doc/fay-peter-v-boston-police-department-71708/download
Finn, Sean v. Boston Police Department - Related Superior Court Decision 12/16/08	https://www.mass.gov/doc/finn-sean-v-boston-police-department-related-superior-court-decision-121608/download
Finn, Sean v. Boston Police Department 8/23/07	https://www.mass.gov/doc/finn-sean-v-boston-police-department-82307/download
Fitzgibbon, Daniel v. Boston Police Department - Related Superior Court Order 4/29/10	https://www.mass.gov/doc/fitzgibbon-daniel-v-boston-police-department-related-superior-court-order-42910/download
Fitzgibbon, Daniel v. Boston Police Department 2/4/10	https://www.mass.gov/doc/fitzgibbon-daniel-v-boston-police-department-2410/download
Gerbutavich, Gregg v. Boston Police Department 3/1/07	https://www.mass.gov/doc/gerbutavich-gregg-v-boston-police-department-3107/download
Hart, Melissa v. Boston Police Department 11/22/06	https://www.mass.gov/doc/hart-melissa-v-boston-police-department-112206/download
Horan, Richard v. Boston Police Department 1/4/07	https://www.mass.gov/doc/horan-richard-v-boston-police-department-1407/download
Jones, Matthew v. Boston Police Department 10/2/08	https://www.mass.gov/doc/jones-matthew-v-boston-police-department-10208/download
Kavaleski, Jill v. Boston Police Department - Related Superior Court Decision 9/9/10	https://www.mass.gov/doc/kavaleski-jill-v-boston-police-department-related-superior-court-decision-9910/download
Kavaleski, Jill v. Boston Police Department - Related Superior Court Ruling 3/9/10	https://www.mass.gov/doc/kavaleski-jill-v-boston-police-department-related-superior-court-ruling-3910/download
Kavaleski, Jill v. Boston Police Department 10/22/09 (Overturned by Superior Court on 9/9/10)	https://www.mass.gov/doc/kavaleski-jill-v-boston-police-department-102209-overturned-by-superior-court-on-9910/download
Lee, Gary v. Boston Police Department - Related Superior Court Decision 10/28/10	https://www.mass.gov/doc/lee-gary-v-boston-police-department-related-superior-court-decision-102810/download
Lee, Gary v. Boston Police Department 4/9/09 (Vacated by Superior Court on 10/28/10)	https://www.mass.gov/doc/lee-gary-v-boston-police-department-4909-vacated-by-superior-court-on-102810/download
Lerro, Shandralee v. Boston Police Department 11/22/06	https://www.mass.gov/doc/lerro-shandralee-v-boston-police-department-112206/download
Lilly, David v. Boston Police Department 1/31/08	https://www.mass.gov/doc/lilly-david-v-boston-police-department-13108/download
McKeown, Mark v. Boston Police Department 1/31/08	https://www.mass.gov/doc/mckeown-mark-v-boston-police-department-13108/download
Monteiro, Lencol v. Boston Police Department 3/28/07	https://www.mass.gov/doc/monteiro-lencol-v-boston-police-department-32807/download
Monteiro, Lencol v. Boston Police Department 8/21/08	https://www.mass.gov/doc/monteiro-lencol-v-boston-police-department-82108/download
Moriarty, Daniel v. Boston Police Department - Related Superior Court Decision 5/12/10	https://www.mass.gov/doc/moriarty-daniel-v-boston-police-department-related-superior-court-decision-51210/download
Moriarty, Daniel v. Boston Police Department 4/9/09 (Overturned by Superior Court on 5/12/10)	https://www.mass.gov/doc/moriarty-daniel-v-boston-police-department-4909-overturned-by-superior-court-on-51210/download
Nahim, William v. Boston Police Department 3/28/07	https://www.mass.gov/doc/nahim-william-v-boston-police-department-32807/download
O'Loughlin, Kevin v. Boston Police Department - Related Superior Court Order 12/6/10	https://www.mass.gov/doc/oloughlin-kevin-v-boston-police-department-related-superior-court-order-12610/download
O'Loughlin, Kevin v. Boston Police Department 5/28/09 (Under Appeal)	https://www.mass.gov/doc/oloughlin-kevin-v-boston-police-department-52809-under-appeal/download
Pinckney, Melissa v. Boston Police Department 2/25/10	https://www.mass.gov/doc/pinckney-melissa-v-boston-police-department-22510/download
Plaza, Justiniano v. Boston Police Department - Related Superior Court Decision 8/19/09	https://www.mass.gov/doc/plaza-justiniano-v-boston-police-department-related-superior-court-decision-81909/download
Plaza, Justiniano v. Boston Police Department 7/10/08 (Vacated and Nullified by Superior Court 8/19/09)	https://www.mass.gov/doc/plaza-justiniano-v-boston-police-department-71008-vacated-and-nullified-by-superior-court-81909/download
Printemps, Gregory v. Boston Police Department 12/30/10	https://www.mass.gov/doc/printemps-gregory-v-boston-police-department-123010/download
Riva, Albert v. Boston Police Department - Related Superior Court Decision 2/12/10	https://www.mass.gov/doc/riva-albert-v-boston-police-department-related-superior-court-decision-21210/download
Riva, Albert v. Boston Police Department 5/22/08 (Reversed by Superior Court on 2/12/10)	https://www.mass.gov/doc/riva-albert-v-boston-police-department-52208-reversed-by-superior-court-on-21210/download
Roberts, Shawn v. Boston Police Department - Related Superior Court Decision 12/30/09	https://www.mass.gov/doc/roberts-shawn-v-boston-police-department-related-superior-court-decision-123009/download
Roberts, Shawn v. Boston Police Department 9/25/08 (Affirmed by Superior Court on 12/30/09)	https://www.mass.gov/doc/roberts-shawn-v-boston-police-department-92508-affirmed-by-superior-court-on-123009/download
Rodrigues, Juan v. Boston Police Department - Related Superior Court Decision 10/23/09	https://www.mass.gov/doc/rodrigues-juan-v-boston-police-department-related-superior-court-decision-102309/download
Rodrigues, Juan v. Boston Police Department 7/31/08 (Vacated by Superior Court on 10/23/09)	https://www.mass.gov/doc/rodrigues-juan-v-boston-police-department-73108-vacated-by-superior-court-on-102309/download
Rodriguez and Araujo v. Boston Police Department 9/10/09	https://www.mass.gov/doc/rodriguez-and-araujo-v-boston-police-department-91009/download
Rodriguez and Araujo v. Boston Police Department 12/10/09	https://www.mass.gov/doc/rodriguez-and-araujo-v-boston-police-department-121009/download
Savickas, Richard v. Boston Police Department 1/7/10	https://www.mass.gov/doc/savickas-richard-v-boston-police-department-1710/download
Suppa, David v. Boston Police Department - Related Superior Court Decision 1/4/10	https://www.mass.gov/doc/suppa-david-v-boston-police-department-related-superior-court-decision-1410/download
Suppa, David v. Boston Police Department 10/30/08 (Vacated by Superior Court on 1/4/10)	https://www.mass.gov/doc/suppa-david-v-boston-police-department-103008-vacated-by-superior-court-on-1410/download
Suppa, David v. Boston Police Department Decision on Motion for Reconsideration 12/18/08	https://www.mass.gov/doc/suppa-david-v-boston-police-department-decision-on-motion-for-reconsideration-121808/download
Torres, Carlos v. Boston Police Department 5/10/07	https://www.mass.gov/doc/torres-carlos-v-boston-police-department-51007/download
Walker, Brian v. Boston Police Department - Related Superior Court Decision 11/29/10	https://www.mass.gov/doc/walker-brian-v-boston-police-department-related-superior-court-decision-112910/download
Walker, Brian v. Boston Police Department 10/29/09 (Vacated by Superior Court on 11/29/10)	https://www.mass.gov/doc/walker-brian-v-boston-police-department-102909-vacated-by-superior-court-on-112910/download
Anderson, Deborah v. Boston Police Department 7/15/10	https://www.mass.gov/doc/anderson-deborah-v-boston-police-department-71510/download
Dambreville, Yves v. Boston Police Department 6/17/10	https://www.mass.gov/doc/dambreville-yves-v-boston-police-department-61710/download
Foley, George v. Boston Police Department 1/15/09	https://www.mass.gov/doc/foley-george-v-boston-police-department-11509/download
Frederick, Roy v. Boston Police Department - Related Superior Court Decision 4/21/09	https://www.mass.gov/doc/frederick-roy-v-boston-police-department-related-superior-court-decision-42109/download
Frederick, Roy v. Boston Police Department 11/8/07	https://www.mass.gov/doc/frederick-roy-v-boston-police-department-11807/download
Gonzalez, Eliezer v. Boston Police Department 1/25/07	https://www.mass.gov/doc/gonzalez-eliezer-v-boston-police-department-12507/download
Hightower, Stacey v. Boston Police Department - Related Superior Court Decision 7/22/10	https://www.mass.gov/doc/hightower-stacey-v-boston-police-department-related-superior-court-decision-72210/download
Hightower, Stacey v. Boston Police Department 5/14/09 (Affirmed by Suprerior Court on 7/22/10)	https://www.mass.gov/doc/hightower-stacey-v-boston-police-department-51409-affirmed-by-suprerior-court-on-72210/download
Hill, Linda v. Boston Police Department 12/13/07	https://www.mass.gov/doc/hill-linda-v-boston-police-department-121307/download
Igoe, Phyllis v. Boston Police Department - Related Superior Court Decision 8/12/10	https://www.mass.gov/doc/igoe-phyllis-v-boston-police-department-related-superior-court-decision-81210/download
Igoe, Phyllis v. Boston Police Department 1/7/10 (Affirmed by Superior Court on 8/12/10)	https://www.mass.gov/doc/igoe-phyllis-v-boston-police-department-1710-affirmed-by-superior-court-on-81210/download
Igoe, Phyllis v. Boston Police Department 7/24/08	https://www.mass.gov/doc/igoe-phyllis-v-boston-police-department-72408/download
Johnson, Charles v. Boston Police Department 10/21/10	https://www.mass.gov/doc/johnson-charles-v-boston-police-department-102110/download
Lacet, Jovan v. Boston Police Department - Related Superior Court Decision 9/29/09	https://www.mass.gov/doc/lacet-jovan-v-boston-police-department-related-superior-court-decision-92909/download
Lacet, Jovan v. Boston Police Department 3/27/08 (Affirmed by Superior Court on 9/29/09)	https://www.mass.gov/doc/lacet-jovan-v-boston-police-department-32708-affirmed-by-superior-court-on-92909/download
Lett, Gerard v. Boston Police Department 6/17/10	https://www.mass.gov/doc/lett-gerard-v-boston-police-department-61710/download
Smith, Tyrone v. Boston Police Department - Related Superior Court Decision 3/9/09	https://www.mass.gov/doc/smith-tyrone-v-boston-police-department-related-superior-court-decision-3909/download
Smith, Tyrone v. Boston Police Department 10/11/07	https://www.mass.gov/doc/smith-tyrone-v-boston-police-department-101107/download
Williams, Frank v. Boston Police Department 9/13/07	https://www.mass.gov/doc/williams-frank-v-boston-police-department-91307/download
Dalrymple and Sexton v. Boston Police Department 02/12/09	https://www.mass.gov/doc/dalrymple-and-sexton-v-boston-police-department-021209/download
Flaherty and McCarthy v. Boston Police Department 1/29/09	https://www.mass.gov/doc/flaherty-and-mccarthy-v-boston-police-department-12909/download
Hamm, Brendan v. Boston Police Department 11/13/08	https://www.mass.gov/doc/hamm-brendan-v-boston-police-department-111308/download
Keller-Brittle, Warren v. Boston Police Department 5/6/10	https://www.mass.gov/doc/keller-brittle-warren-v-boston-police-department-5610/download
O'Connor, Gillespie and Hopkins v. Boston Police Department 11/12/09	https://www.mass.gov/doc/oconnor-gillespie-and-hopkins-v-boston-police-department-111209/download
Thomas et al v. Boston Police Department 9/18/08	https://www.mass.gov/doc/thomas-et-al-v-boston-police-department-91808/download
Verderico and O'Sullivan v. Boston Police Department and HRD 3/27/08	https://www.mass.gov/doc/verderico-and-osullivan-v-boston-police-department-and-hrd-32708/download
"""

TXT.strip.each_line do |line|
  case_name, file_url = line.strip.split("\t", 2)
  file_name = file_url.sub(%r{/download.*}, "")
  file_name = file_name.sub(%r{.*/}, "") + ".pdf"
  file_path = "data/civil_service_decisions/#{file_name}"
  body = IO.read(file_path.sub(/pdf$/, "txt"))
  article = Article.find_by(url: file_url) || Article.new
  article.url = file_url
  article.title = case_name
  article.body = body
  if %r{\d{1,2}/\d{1,2}/\d{2,4}}.match(case_name)
    article.date_published = Chronic.parse($&).strftime("%F")
  end
  begin
    article.save
  rescue ActiveRecord::RecordNotUnique
  end
end
