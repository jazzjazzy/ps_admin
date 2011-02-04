# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v6.0.0                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          people_scope.dez                                #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database drop script                            #
# Created on:            2011-02-01 09:54                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Drop foreign key constraints                                           #
# ---------------------------------------------------------------------- #

ALTER TABLE `advertisement` DROP FOREIGN KEY `role_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `category_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `office_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `department_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `state_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `store_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `advertisement_question_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `storerole_advertisement`;

ALTER TABLE `advertisement` DROP FOREIGN KEY `questionTracking_advertisement`;

ALTER TABLE `department` DROP FOREIGN KEY `office_department_department`;

ALTER TABLE `role` DROP FOREIGN KEY `department_role`;

ALTER TABLE `store` DROP FOREIGN KEY `state_store`;

ALTER TABLE `question` DROP FOREIGN KEY `question_multi_question`;

ALTER TABLE `question` DROP FOREIGN KEY `advertisement_question_question`;

ALTER TABLE `question` DROP FOREIGN KEY `question_catagory_question`;

ALTER TABLE `question` DROP FOREIGN KEY `questionTracking_question`;

ALTER TABLE `applications_question` DROP FOREIGN KEY `question_applications_question`;

ALTER TABLE `office_department` DROP FOREIGN KEY `office_office_department`;

ALTER TABLE `application` DROP FOREIGN KEY `applications_question_application`;

ALTER TABLE `application` DROP FOREIGN KEY `advertisement_application`;

ALTER TABLE `application` DROP FOREIGN KEY `referral_application`;

ALTER TABLE `application` DROP FOREIGN KEY `contact_type_application`;

ALTER TABLE `application` DROP FOREIGN KEY `application_status_application`;

ALTER TABLE `application` DROP FOREIGN KEY `applicants_application`;

ALTER TABLE `template` DROP FOREIGN KEY `template_question_template`;

ALTER TABLE `template` DROP FOREIGN KEY `category_template`;

ALTER TABLE `template` DROP FOREIGN KEY `state_template`;

ALTER TABLE `template` DROP FOREIGN KEY `office_template`;

ALTER TABLE `template` DROP FOREIGN KEY `role_template`;

ALTER TABLE `template` DROP FOREIGN KEY `store_template`;

ALTER TABLE `template` DROP FOREIGN KEY `department_template`;

ALTER TABLE `template_question` DROP FOREIGN KEY `question_template_question`;

ALTER TABLE `applicantion_notes` DROP FOREIGN KEY `application_applicantion_notes`;

ALTER TABLE `applicantion_notes` DROP FOREIGN KEY `applicants_applicantion_notes`;

ALTER TABLE `users` DROP FOREIGN KEY `division_users`;

ALTER TABLE `users` DROP FOREIGN KEY `administration_users`;

ALTER TABLE `referral_cost` DROP FOREIGN KEY `advertisement_referral_cost`;

ALTER TABLE `referral_cost` DROP FOREIGN KEY `referral_referral_cost`;

# ---------------------------------------------------------------------- #
# Drop table "template"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `template` MODIFY `template_id` BIGINT NOT NULL;

# Drop constraints #

ALTER TABLE `template` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `template`;

# ---------------------------------------------------------------------- #
# Drop table "employmenttype"                                            #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `employmenttype` MODIFY `employmenttype_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `employmenttype` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `employmenttype`;

# ---------------------------------------------------------------------- #
# Drop table "referral_cost"                                             #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `referral_cost` MODIFY `referal_cost_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `referral_cost` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `referral_cost`;

# ---------------------------------------------------------------------- #
# Drop table "applicantion_notes"                                        #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `applicantion_notes` MODIFY `notes_id` BIGINT NOT NULL;

# Drop constraints #

ALTER TABLE `applicantion_notes` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `applicantion_notes`;

# ---------------------------------------------------------------------- #
# Drop table "application"                                               #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `application` MODIFY `application_id` INTEGER NOT NULL COMMENT 'Primary key for applications table ';

# Drop constraints #

ALTER TABLE `application` ALTER COLUMN `viewed` DROP DEFAULT;

ALTER TABLE `application` ALTER COLUMN `status_id` DROP DEFAULT;

ALTER TABLE `application` ALTER COLUMN `saved` DROP DEFAULT;

ALTER TABLE `application` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `application`;

# ---------------------------------------------------------------------- #
# Drop table "advertisement"                                             #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `advertisement` MODIFY `advertisement_id` BIGINT NOT NULL;

# Drop constraints #

ALTER TABLE `advertisement` ALTER COLUMN `cover_letter` DROP DEFAULT;

ALTER TABLE `advertisement` ALTER COLUMN `status` DROP DEFAULT;

ALTER TABLE `advertisement` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `advertisement`;

# ---------------------------------------------------------------------- #
# Drop table "users"                                                     #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `users` MODIFY `user_id` INTEGER NOT NULL COMMENT 'Primary Key for the users table, does not use auto increament, as we define the key based on the matching user id in the ps_admin.users table';

# Drop constraints #

ALTER TABLE `users` ALTER COLUMN `active` DROP DEFAULT;

ALTER TABLE `users` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `users`;

# ---------------------------------------------------------------------- #
# Drop table "template_question"                                         #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `template_question` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `template_question`;

# ---------------------------------------------------------------------- #
# Drop table "applications_question"                                     #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `applications_question` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `applications_question`;

# ---------------------------------------------------------------------- #
# Drop table "question"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `question` MODIFY `question_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `question` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `question`;

# ---------------------------------------------------------------------- #
# Drop table "role"                                                      #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `role` MODIFY `role_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `role` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `role`;

# ---------------------------------------------------------------------- #
# Drop table "department"                                                #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `department` MODIFY `dept_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `department` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `department`;

# ---------------------------------------------------------------------- #
# Drop table "administration"                                            #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `administration` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `administration`;

# ---------------------------------------------------------------------- #
# Drop table "division"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `division` MODIFY `division_id` INTEGER NOT NULL COMMENT 'The Division key for the divisions table ';

# Drop constraints #

ALTER TABLE `division` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `division`;

# ---------------------------------------------------------------------- #
# Drop table "storerole"                                                 #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `storerole` MODIFY `storerole_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `storerole` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `storerole`;

# ---------------------------------------------------------------------- #
# Drop table "question_catagory"                                         #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `question_catagory` MODIFY `question_catagory_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `question_catagory` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `question_catagory`;

# ---------------------------------------------------------------------- #
# Drop table "application_status"                                        #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `application_status` MODIFY `status_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `application_status` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `application_status`;

# ---------------------------------------------------------------------- #
# Drop table "referral"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `referral` MODIFY `referral_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `referral` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `referral`;

# ---------------------------------------------------------------------- #
# Drop table "contact_type"                                              #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `contact_type` MODIFY `contact_type_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `contact_type` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `contact_type`;

# ---------------------------------------------------------------------- #
# Drop table "applicants"                                                #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `applicants` MODIFY `applicant_id` BIGINT NOT NULL COMMENT 'Primary Id for the table';

# Drop constraints #

ALTER TABLE `applicants` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `applicants`;

# ---------------------------------------------------------------------- #
# Drop table "questionTracking"                                          #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `questionTracking` MODIFY `tracking_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `questionTracking` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `questionTracking`;

# ---------------------------------------------------------------------- #
# Drop table "office_department"                                         #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `office_department` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `office_department`;

# ---------------------------------------------------------------------- #
# Drop table "advertisement_question"                                    #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `advertisement_question` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `advertisement_question`;

# ---------------------------------------------------------------------- #
# Drop table "question_multi"                                            #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `question_multi` MODIFY `multi_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `question_multi` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `question_multi`;

# ---------------------------------------------------------------------- #
# Drop table "store"                                                     #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `store` MODIFY `store_location_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `store` ALTER COLUMN `deleted` DROP DEFAULT;

ALTER TABLE `store` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `store`;

# ---------------------------------------------------------------------- #
# Drop table "state"                                                     #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `state` MODIFY `state_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `state` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `state`;

# ---------------------------------------------------------------------- #
# Drop table "office"                                                    #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `office` MODIFY `office_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `office` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `office`;

# ---------------------------------------------------------------------- #
# Drop table "category"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `category` MODIFY `catagory_id` INTEGER NOT NULL;

# Drop constraints #

ALTER TABLE `category` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `category`;
