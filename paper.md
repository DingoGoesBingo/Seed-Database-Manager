---
title: 'Seed Database Manager: an open-source tool for germplasm information management'
tags:
- shiny R
- germplasm
- database
- seed information
date: "14 March 2025"
affiliations:
- name: Purdue University, United States
  index: 1
authors:
- name: Sam E. Schafer
  orcid: "0009-0002-8034-6783"
  equal-contrib: true
  affiliation: 1
- name: Diane R. Wang
  orcid: "0000-0002-2290-3257"
  equal-contrib: true
  affiliation: 1
bibliography: paper.bib
---

# Summary

Record-keeping of plant germplasm in smaller research teams relies on one of several approaches: digital spreadsheets or paper records, commercially available software for database management, or independently developed solutions. The latter two require additional capital or time investment to properly utilize. The Seed Database Manager (SDM) is an open-source Shiny R application designed to provide an affordable, easy-to-use, and accessible method to store, browse, and modify plant germplasm information. The set-up process for the SDM enables deployment either locally or through any hosting platforms that support Shiny R [@shiny:2024] applications and PostgreSQL (PostgreSQL Global Development Group, https://www.postgresql.org) databases with minimal modifications made by the user. Upon successful deployment, a simplified user interface allows researchers to browse existing entries, enter in new information, and append new information to entries post-hoc. Each seed packet registered to the database is associated with a unique, customizable tag that is intended to help simplify the relationship between entries while also organizing the database chronologically. Code for the SDM is available on GitHub under the Non-Profit Open Software License 3.0 and can be further modified to fit researcher needs.

# Statement of need

Research conducted within plant sciences often involve exchange and amplification of seed. A single research group may handle several plant species in addition to numerous distinct varieties within each species. It is critical that regular records of germplasm be made to keep track of germplasm relationships, prevent information gaps associated with staff turnover, and to monitor the progress of the program [@tiwari2023germplasm:2023]. Larger organizations that maintain germplasm collections have their own strategies and specialized collection management systems that are often not applicable to smaller-scale research teams, such as those found at research universities. Existing tools, such as commercially available software, specially designed data management systems, or usage of digital or paper spreadsheets, are not always be easily accessible, require additional capital investment, or are better suited for larger-scale breeding programs. Open-source systems like the Breeding Information Management System [@jung2021breeding:2021], Breedbase [@morales2022breedbase:2022], Germinate [@shaw2017germinate:2017], and the discontinued International Crop Information System (ICIS) [@portugal2007international:2007] require significant technical knowledge to initiate or were intended for larger plant breeding operations and are not ideal for simple germplasm record-keeping. Additionally, acquisition of germplasm from separate sources (e.g., retrieval from external sources such as collaborating groups and nationally maintained gene banks, or generation internally through propagation of seeds), utilize different naming conventions and introduces an extra layer of complication for archiving information as a result. Lastly, due to individual needs among different research groups, it is important that existing tools be easily tailored to better serve the needs of each group. The development of an accessible and adaptable open-source seed management tool would greatly enhance the capacity of plant science research groups to track their seed collections.

The Seed Database Manager (SDM) is a database-navigating application developed in Shiny R that provides an easy-to-use, centralized, and accessible platform to store all relevant germplasm information. The SDM aims to resolve the germplasm organization problem by adapting each entry into a uniform format that archives information on species, common name and any associated IDs, proximal source of the seed, harvest date, relevant researcher, and other descriptive information. Following submission into the database, each entry receives its own unique, chronological, and customizable identifying tag. This format allows the database to be as flexible as possible to account for different types of information given within each set of germplasm, as well as simplifies pedigree tracking down to the tracking of entry tags. The SDM is designed to connect to a PostgreSQL database through the utilization of the Rpostgres [@RPostgres:2024] package, which can be easily configured to run via local machines or through deployment onto an external hosting platform, greatly enhancing the accessibility of the stored data. Additionally, all database-modifying operations are restricted to authorized users determined at the set-up process, allowing for a more secure platform. All functionality of this open-source software is achieved using R programming, which is accessible to biologists within and outside of the realm of plant sciences.

# Figures

![A. Example pipeline for information tracking of amplified seed using the SDM, wherein the discovery of new information, such as the observation of off-type plants, is used to update previous entries. B. Information of seed packets received from various sources are conformed to a uniform format ahead of entry into the database.](SDM_Figure_1.png)

# Acknowledgements

We thank all the members of the Wang lab who helped test this application from its inception to release and Jason King for contributing code related to database connections. Development of this application was supported by grants to D.R.W. (USDA AFRI #2022-67013-36205 and NSF-PGRP #2102120). 

# References

Jung, S., Lee, T., Gasic, K., Campbell, B. T., Yu, J., Humann, J., Ru, S., Edge-Garza, D., Hough, H., & Main, D. (2021). The Breeding Information Management System (BIMS): An online resource for crop breeding. Database, 2021, baab054. https://doi.org/10.1093/database/baab054
Morales, N., Ogbonna, A. C., Ellerbrock, B. J., Bauchet, G. J., Tantikanjana, T., Tecle, I. Y., Powell, A. F., Lyon, D., Menda, N., Simoes, C. C., Saha, S., Hosmani, P., Flores, M., Panitz, N., Preble, R. S., Agbona, A., Rabbi, I., Kulakow, P., Peteti, P., … Mueller, L. A. (2022). Breedbase: A digital ecosystem for modern plant breeding. G3 Genes|Genomes|Genetics, 12(7), jkac078. https://doi.org/10.1093/g3journal/jkac078
Portugal, A., Balachandra, R., Metz, T., Bruskiewich, R., & McLaren, G. (2007). International Crop Information System for Germplasm Data Management. In D. Edwards (Ed.), Plant Bioinformatics: Methods and Protocols (pp. 459–471). Humana Press. https://doi.org/10.1007/978-1-59745-535-0_22
Shaw, P. D., Raubach, S., Hearne, S. J., Dreher, K., Bryan, G., McKenzie, G., Milne, I., Stephen, G., & Marshall, D. F. (2017). Germinate 3: Development of a Common Platform to Support the Distribution of Experimental Data on Crop Wild Relatives. Crop Science, 57(3), 1259–1273. https://doi.org/10.2135/cropsci2016.09.0814
Tiwari, A., Tikoo, S. K., Angadi, S. P., Kadaru, S. B., Ajanahalli, S. R., & Vasudeva Rao, M. J. (2022). Germplasm Management in Commercial Plant Breeding Programs. In A. Tiwari, S. K. Tikoo, S. P. Angadi, S. B. Kadaru, S. R. Ajanahalli, & M. J. Vasudeva Rao (Eds.), Market-Driven Plant Breeding for Practicing Breeders (pp. 33–68). Springer Nature. https://doi.org/10.1007/978-981-19-5434-4_2