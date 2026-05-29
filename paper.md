---
title: 'Seed Database Manager: an open-source tool for germplasm information management'
tags:
- shiny R
- germplasm
- database
- seed information
date: "29 May 2026"
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

Record-keeping of plant germplasm in smaller research teams, such as those at universities, relies on one of several approaches: digital spreadsheets or paper records, commercially available software for database management, or independently developed solutions. The latter two require additional capital or time investment to implement. The Seed Database Manager (SDM) is an open-source Shiny R application designed to provide a free, easy-to-use, and accessible method to store, browse, and modify plant germplasm information. SDM can be deployed locally or through any hosting platform that supports Shiny R [@shiny:2024] applications and PostgreSQL (PostgreSQL Global Development Group, https://www.postgresql.org) databases with minimal modifications made by the user. Upon successful deployment, a simplified user interface allows researchers to browse existing entries, enter new information, and append new information to entries post-hoc. Each seed packet registered to the database is associated with a unique, customizable tag intended to simplify the relationship between entries while also organizing the database chronologically. Code for the SDM is available on GitHub under the MIT license and can be further modified to fit researcher needs.

# Statement of need

Research conducted within plant sciences often involves exchange of genetic material in the form of seeds along with amplification of these seeds. A single research group may handle several plant species in addition to numerous distinct varieties within each species. It is critical that regular records of germplasm be made to keep track of germplasm relationships, prevent information gaps associated with staff turnover, and to monitor the progress of the program [@tiwari2023germplasm:2023]. Open-source systems like the Breeding Information Management System (BIMS) [@jung2021breeding:2021], Breedbase [@morales2022breedbase:2022], Germinate [@shaw2017germinate:2017], and the discontinued International Crop Information System (ICIS) [@portugal2007international:2007] require significant technical knowledge to initiate or were intended for larger plant breeding operations and are not ideal for simple germplasm record-keeping (e.g., those needed by plant physiology or ecology research groups). Larger organizations that maintain germplasm collections have their own strategies and specialized collection management systems that are often not applicable to smaller-scale research teams, such as those found at research universities. Existing tools, such as commercially available software, specially designed data management systems, or usage of digital or paper spreadsheets, are not always be easily accessible, require additional capital investment, or are better suited for larger-scale breeding programs. Additionally, acquisition of germplasm from separate sources (e.g., retrieval from external sources such as collaborating groups and nationally maintained gene banks, or generation internally through propagation of seeds), utilize different naming conventions and introduces an extra layer of complication for archiving information as a result. Lastly, due to individual needs among different research groups, it is important that existing tools enable customization to better serve the needs of each group. The development of an accessible and adaptable open-source seed management tool would enhance the capacity of plant science research groups to track their seed collections and help support reproducible science.

The Seed Database Manager (SDM) is a database-navigating application developed in Shiny R that provides an easy-to-use, centralized, and accessible platform to store all relevant germplasm information. The SDM aims to resolve the germplasm organization problem by adapting each entry into a uniform format that archives information on species, common name and any associated IDs, proximal source of the seed, harvest date, relevant researcher, and other descriptive information. Following submission into the database, each entry receives its own unique, chronological, and customizable identifying tag. This format allows the database to be as flexible as possible to account for different types of information given within each set of germplasm, as well as simplifies pedigree tracking down to the tracking of entry tags. The SDM is designed to connect to a PostgreSQL database through the utilization of the Rpostgres [@RPostgres:2024] package, which can be easily configured to run via local machines or through deployment onto an external hosting platform, greatly enhancing the accessibility and flexibility of the stored data. Additionally, all database-modifying operations are restricted to authorized users determined at the set-up process, allowing for a more secure platform. All functionality of this open-source software is achieved using R programming, which is accessible to biologists at large.

# Statement of field

Several commercial and open-source database tools exist for plant breeding purposes, but are not intended for small-scale research programs. The two open-source database software most comparable to the SDM are Breedbase and BIMS, which both provide tools for both the storage and analysis of genetic and phenotypic data and are meant for heavy integration into plant breeding programs. While useful, the inclusion of this suite of features results in less efficient usage for research groups that only require a simplified method of germplasm tracking. To this end, the SDM is not designed to replace or compete with feature-rich software for intensive plant breeding applications, but rather is meant to provide a streamlined alternative to spreadsheet record-keeping of plant accessions for groups that do not require an extensive toolset for breeding work, such as those working primarily in the fields of plant physiology and ecology.

# Software design

To promote accessibility for a wide range of research groups, the SDM user interface allows for rapid customization, deployment, and operation with minimal technical input from the user. Deploying an offline version of the application to a local machine provides the most straight-forward setup for the user, however connection to an external database host requires users have access to a pre-setup PostgreSQL database and all connection parameters necessary. Since there are no restrictions on external database-hosting platforms, groups who work with sensitive germplasm information are recommended to use only secure services offered by their institution or deploy the application via a local, offline machine. Considering the variation present in accession nomenclature and passport information utilized across industry and academia, the data storage format was designed to be broadly applicable to most information types, and consequently may not be the ideal structure for any one particular research group. Groups willing to modify the software may re-shape the SDM to a form that best suits their program’s needs by editing few base R scripts. 

# Research impact statement

Technical knowledge, capital, and time investment often act as the main barriers preventing small programs from implementing database management tools into their research. The simplified and flexible design for setup and operation of the SDM aims to lower the barrier of entry and enhance the efficiency of independent research programs. In addition to this, the SDM offers a long-term and accessible storage solution of germplasm records and can potentially reduce the loss of information during staff turnover. Lastly, the unified format of data storage allows for the homogenization and linking of all pedigree records internally produced or externally received, allowing for simplified tracking of germplasm origins. 

# AI usage disclosure

Large-language models were utilized solely for the identification of various tools and R packages and for troubleshooting during development, and otherwise played no major material role in either in programming or software design. 

# Figures

![A. Example pipeline for information tracking of amplified seed using the SDM, wherein the discovery of new information, such as the observation of off-type plants, is used to update previous entries. B. Information of seed packets received from various sources are conformed to a uniform format ahead of entry into the database.](SDM_Figure_1.png)

# Acknowledgements

We thank all the members of the Wang lab who helped us test and improve this application from its inception to release. Development of this application was supported by grants to D.R.W. (USDA AFRI #2022-67013-36205 and NSF-PGRP #2102120). 

# References