2016 Citizen Voting Age Population (CVAP) Data for North Carolina from the American Community Survey (ACS) 5-Year Estimates (2012-2016) Disaggregated to 2020 Census Blocks

##Redistricting Data Hub (RDH) Retrieval Date
05/13/21 for 2016 CVAP Data
11/11/21 for 2010 Public Law 94-161 Data
04/14/21 for Voting Election and Science Team (VEST) Crosswalk Tabulations

##Sources
CVAP Data retrieved from the Census Citizen Voting Age Population by Race and Ethnicity website: https://www.census.gov/programs-surveys/decennial-census/about/voting-rights/cvap.2016.html
Public Law 94-161 Data was retrieved using the Census API, variables are available here: https://api.census.gov/data/2010/dec/pl/variables.html
VEST Crosswalk tabulations were retrieved here: https://dataverse.harvard.edu/file.xhtml?fileId=4513650&version=2.0

##Fields
     Field Name			Description

     GEOID20                 	Unique Identifier
     CVAP_TOT16                 CVAP Estimate for Total
     CVAP_NHS16                 CVAP Estimate for Not Hispanic or Latino
     CVAP_AIA16            	CVAP Estimate for American Indian or Alaska Native Alone or In Combination
     CVAP_ASN16                 CVAP Estimate for Asian Alone or In Combination
     CVAP_BLK16                 CVAP Estimate for Black or African American Alone or In Combination
     CVAP_NHP16                 CVAP Estimate for Native Hawaiian or Other Pacific Islander Alone
     CVAP_WHT16                 CVAP Estimate for White Alone
     CVAP_AIW16                 CVAP Estimate for American Indian or Alaska Native and White
     CVAP_ASW16                 CVAP Estimate for Asian and White
     CVAP_BLW16                 CVAP Estimate for Black or African American and White
     CVAP_AIB16            	CVAP Estimate for American Indian or Alaska Native and Black or African American
     CVAP_2OM16                 CVAP Estimate for Remainder of Two or More Race Responses
     CVAP_HSP16                 CVAP Estimate for Hispanic or Latino      
     C_TOT16                    Citizen Estimate for Total
     C_NHS16                    Citizen Estimate for Not Hispanic or Latino
     C_AIA16               	Citizen Estimate for American Indian or Alaska Native Alone or In Combination
     C_ASN16                    Citizen Estimate for Asian Alone or In Combination
     C_BLK16                    Citizen Estimate for Black or African American Alone or In Combination
     C_NHP16                    Citizen Estimate for Native Hawaiian or Other Pacific Islander Alone
     C_WHT16                    Citizen Estimate for White Alone
     C_AIW16                    Citizen Estimate for American Indian or Alaska Native and White
     C_ASW16                    Citizen Estimate for Asian and White
     C_BLW16                    Citizen Estimate for Black or African American and White
     C_AIB16         		Citizen Estimate for American Indian or Alaska Native and Black or African American
     C_2OM16                    Citizen Estimate for Remainder of Two or More Race Responses
     C_HSP16                    Citizen Estimate for Hispanic or Latino

##Processing
The processing for this dataset was completed in multiple parts.

Part 1: Processing the 2016 Block Group CVAP data

CVAP data was retrieved at the block group level from link in "Sources" above.
The North Carolina data was extracted from the national data to create a statewide dataset.
The data was pivoted from narrow to wide data based on GEOIDs so that one row is one block group, and each field represents a particular race/ethnicity. 
The fields were renamed to fit character length requirements. 
Processing was primarily completed using the pandas library.
To improve the usefulness of the data, we have modified three categories to correspond with the Office of Management and Budget (OMB) racial categories. The "Alone" categories for American Indian or Alaska Native (fields with "AIA"), Asian (fields with "ASN"), and Black or African American (fields with "BLK") represent an encompassing racial category that is inclusive of all categories that include that race. For example, CVAP_AIA16 would be the sum of the original "Alone" CVAP_AIA16, CVAP_AIB16, and CVAP_AIW16. For CVAP_BLK16, the field would be the sum of the original CVAP_BLK16, CVAP_AIB16, and CVAP_BLW16. For CVAP_ASN16, the field would be the sum of the original CVAP_ASN16 and CVAP_ASW16 These fields are also noted in the description as being "Alone or In Combination". No other estimate categories were modified.
All of the racial estimates provided are Non-Hispanic. Breakdowns for Hispanic/Non-Hispanic by race are not provided in the CVAP special tabulation.

Part 2: Disaggregating the 2016 Block Group CVAP data to 2010 Blocks

The 2016 CVAP data was disaggregated using 2010 PL 94-161 data. Using the Census API, the following variables were retrieved (some were summed, as indicated, to better resemble the OMB categories the CVAP modifications):
P004001		CVAP_TOT16
P004003		CVAP_NHS16
P004007		CVAP_AIA16
P004008		CVAP_ASN16
P004006		CVAP_BLK16
P004009		CVAP_NHP16
P004005		CVAP_WHT16
P004014		CVAP_AIW16
P004015		CVAP_ASW16
P004013		CVAP_BLW16
P004018		CVAP_AIB16
P004011		CVAP_2OM16
P004002		CVAP_HSP16
P002001		C_TOT16
P002003		C_NHS16
P002007		C_AIA16
P002008		C_ASN16
P002006		C_BLK16
P002009		C_NHP16
P002005		C_WHT16
P002014		C_AIW16
P002015		C_ASW16
P002013		C_BLW16
P002018		C_AIB16
P002011		C_2OM16
P002002		C_HSP16

After retrieving the data from the API, the OMB categories were created using the same method as the 2016 block group CVAP data.

For each block in each column (e.g. CVAP_TOT16) the value for the 2010 block retrieved from the API was divided by the 2010 total for the block group.
The totals for the block group were retrieved by grouping the block data by block group ID. 
This provides a ratio of block to block group population for each individual racial category.
The ratios for each block in each column were multiplied by the 2016 CVAP total for the block's corresponding block group.
In the scenario where no blocks in a block group contain a value for a particular race/ethnicity combination in 2010, but have a value in the 2016 estimates, total CVAP population or total citizen estimate population were used as a proxy, depending on the variable.
In the scenario where no blocks in a block group contain a value for either the C_TOT16 category or CVAP_TOT16 categories, the 2016 population is divided evenly amongst all blocks in the block group.

Part 3: Transforming 2010 Blocks to 2020 Blocks

To translate the 2010 blocks with 2016 CVAP data to 2020 blocks, the VEST crosswalks were used (see link above in source for more information).
For each 2020 block, a weighted dictionary was retrieved from the 2010 data using the crosswalk tabulations.
For example, 2020 Block 001 could have a weighted dictionary that may look like {001: 1.0, 002: 0.5} where for all columns, the 2020 Block 001 should be assigned the entirety of the 2010 Block 001 and half of 2010 Block 002.
The results were rounded to the nearest hundredth.

All results were verified throughout the process to ensure that data was not being omitted and the totals of disaggregated data on 2020 blocks is nearly the same as the original 2016 block group totals (very slight differences may occur due to the lack of rounding until the final product).

##Additional Notes
For more information on the ACS CVAP documentation please refer to the ACS link above in Sources as well as the ACS technical documentation included in this folder (also available at this link: https://www2.census.gov/programs-surveys/decennial/rdo/technical-documentation/special-tabulation/CVAP_2012-2016_ACS_documentation.pdf ).
For more information on OMB racial categories, please see this link: https://obamawhitehouse.archives.gov/omb/bulletins_b00-02/#n_1_
For more information on VEST crosswalk tabulations, please refer to their documentation here (note that the files used in this process is block10block20_crosswalks.zip): https://dataverse.harvard.edu/file.xhtml?fileId=4575858&version=2.0
Visit the RDH GitHub and the processing script for this code here: https://github.com/nonpartisan-redistricting-datahub/
Please direct questions related to processing this dataset to info@redistrictingdatahub.org.