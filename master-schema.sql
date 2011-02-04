# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v6.0.0                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          people_scope.dez                                #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database creation script                        #
# Created on:            2011-02-01 09:54                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Tables                                                                 #
# ---------------------------------------------------------------------- #

# ---------------------------------------------------------------------- #
# Add table "advertisement"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `advertisement` (
    `advertisement_id` BIGINT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255),
    `catagory_id` INTEGER NOT NULL,
    `template_id` INTEGER,
    `office_id` INTEGER NOT NULL,
    `dept_id` INTEGER NOT NULL,
    `role_id` INTEGER NOT NULL,
    `state_id` INTEGER NOT NULL,
    `store_location_id` INTEGER NOT NULL COMMENT 'Recordes id for store location ',
    `storerole_id` INTEGER NOT NULL,
    `start_date` DATE,
    `end_date` DATE,
    `discription` TEXT,
    `requirments` TEXT,
    `upload_resume` BOOL,
    `cover_letter` BOOL DEFAULT 0,
    `status` BOOL DEFAULT 1,
    `employmenttype_id` INTEGER,
    `create_date` DATETIME,
    `create_by` INTEGER,
    `modify_date` DATETIME,
    `modify_by` INTEGER,
    `delete_date` VARCHAR(40),
    `delete_by` VARCHAR(40),
    CONSTRAINT `PK_advertisement` PRIMARY KEY (`advertisement_id`, `catagory_id`, `office_id`, `dept_id`, `role_id`, `state_id`, `store_location_id`, `storerole_id`)
);

# ---------------------------------------------------------------------- #
# Add table "category"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `category` (
    `catagory_id` INTEGER NOT NULL AUTO_INCREMENT,
    `catagory_name` VARCHAR(40),
    `create_date` DATETIME,
    `modify_date` DATETIME,
    `delete_date` DATETIME,
    CONSTRAINT `PK_category` PRIMARY KEY (`catagory_id`)
);

# ---------------------------------------------------------------------- #
# Add table "office"                                                     #
# ---------------------------------------------------------------------- #

CREATE TABLE `office` (
    `office_id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40),
    `state_id` INTEGER,
    CONSTRAINT `PK_office` PRIMARY KEY (`office_id`)
);

# ---------------------------------------------------------------------- #
# Add table "department"                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE `department` (
    `dept_id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40),
    `office_id` INTEGER NOT NULL,
    CONSTRAINT `PK_department` PRIMARY KEY (`dept_id`, `office_id`)
);

# ---------------------------------------------------------------------- #
# Add table "role"                                                       #
# ---------------------------------------------------------------------- #

CREATE TABLE `role` (
    `role_id` INTEGER NOT NULL AUTO_INCREMENT,
    `dept_id` INTEGER NOT NULL,
    `name` VARCHAR(40),
    `office_id` INTEGER NOT NULL,
    CONSTRAINT `PK_role` PRIMARY KEY (`role_id`, `dept_id`, `office_id`)
);

# ---------------------------------------------------------------------- #
# Add table "state"                                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE `state` (
    `state_id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40),
    `short_name` VARCHAR(40),
    CONSTRAINT `PK_state` PRIMARY KEY (`state_id`)
);
INSERT INTO state (name, short_name) values
('Australian Capital Territory', 'ACT'),
('New South Wales', 'NSW'),
('Victoria', 'VIC'),
('Queensland', 'QLD'),
('South Australia', 'SA'),
('Western Australia', 'WA'),
('Tasmania', 'TAS'),
('Northern Territory', 'NT');

# ---------------------------------------------------------------------- #
# Add table "store"                                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE `store` (
    `store_location_id` INTEGER NOT NULL AUTO_INCREMENT,
    `state_id` INTEGER NOT NULL,
    `location` VARCHAR(40),
    `address` VARCHAR(255),
    `phone` VARCHAR(40),
    `deleted` BOOL DEFAULT 0,
    CONSTRAINT `PK_store` PRIMARY KEY (`store_location_id`, `state_id`)
);

# ---------------------------------------------------------------------- #
# Add table "question"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `question` (
    `question_id` INTEGER NOT NULL AUTO_INCREMENT,
    `question_catagory_id` INTEGER,
    `advertisement_id` INTEGER NOT NULL,
    `label` VARCHAR(255),
    `type` VARCHAR(40),
    `create_date` DATETIME,
    `create_by` INTEGER,
    `modify_date` DATETIME,
    `modify_by` INTEGER,
    `delete_date` DATETIME,
    `delete_by` INTEGER,
    CONSTRAINT `PK_question` PRIMARY KEY (`question_id`, `advertisement_id`)
);

# ---------------------------------------------------------------------- #
# Add table "question_multi"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `question_multi` (
    `multi_id` INTEGER NOT NULL AUTO_INCREMENT,
    `question_id` INTEGER,
    `label` VARCHAR(255),
    `value` VARCHAR(40),
    CONSTRAINT `PK_question_multi` PRIMARY KEY (`multi_id`)
);

# ---------------------------------------------------------------------- #
# Add table "advertisement_question"                                     #
# ---------------------------------------------------------------------- #

CREATE TABLE `advertisement_question` (
    `advertisement_id` BIGINT NOT NULL,
    `question_id` INTEGER NOT NULL,
    `sort` BIGINT,
    CONSTRAINT `PK_advertisement_question` PRIMARY KEY (`advertisement_id`, `question_id`)
);

# ---------------------------------------------------------------------- #
# Add table "applications_question"                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE `applications_question` (
    `application_id` INTEGER NOT NULL,
    `question_id` INTEGER NOT NULL,
    `multi_id` INTEGER NOT NULL,
    `value` TEXT,
    `tracking_id` INTEGER NOT NULL,
    `advertisement_id` INTEGER NOT NULL,
    CONSTRAINT `PK_applications_question` PRIMARY KEY (`application_id`, `question_id`, `multi_id`, `tracking_id`, `advertisement_id`)
);

# ---------------------------------------------------------------------- #
# Add table "office_department"                                          #
# ---------------------------------------------------------------------- #

CREATE TABLE `office_department` (
    `office_id` INTEGER NOT NULL,
    `dept_id` INTEGER NOT NULL,
    CONSTRAINT `PK_office_department` PRIMARY KEY (`office_id`, `dept_id`)
);

# ---------------------------------------------------------------------- #
# Add table "questionTracking"                                           #
# ---------------------------------------------------------------------- #

CREATE TABLE `questionTracking` (
    `tracking_id` INTEGER NOT NULL AUTO_INCREMENT,
    `advertisement_id` INTEGER NOT NULL,
    `multi_id` INTEGER,
    `responce_value` VARCHAR(255),
    CONSTRAINT `PK_questionTracking` PRIMARY KEY (`tracking_id`, `advertisement_id`)
);

# ---------------------------------------------------------------------- #
# Add table "applicants"                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE `applicants` (
    `applicant_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Primary Id for the table',
    `email` VARCHAR(40) COMMENT 'Email Address used, matching email are constidered the same person ',
    `cookie` VARCHAR(40) COMMENT 'Cookie to be used for the user',
    `first_name` VARCHAR(40) COMMENT 'Given name of the applicant',
    `last_name` VARCHAR(40) COMMENT 'Surname of the applicant',
    CONSTRAINT `PK_applicants` PRIMARY KEY (`applicant_id`)
) COMMENT = 'This table is used to keep track of applicants that have applyed for a job, applicants that use the same email address or are using the same cookie are assumed to be the same person, so a history can be tracked';

# ---------------------------------------------------------------------- #
# Add table "application"                                                #
# ---------------------------------------------------------------------- #

CREATE TABLE `application` (
    `application_id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Primary key for applications table ',
    `applicant_id` INTEGER NOT NULL COMMENT 'The key for applicants table, so we can group together applicants by there email address and/or cookie information ',
    `advertisement_id` INTEGER NOT NULL,
    `catagory_id` INTEGER NOT NULL,
    `viewed` BOOL DEFAULT 0,
    `create_date` DATETIME,
    `contact_type_id` INTEGER,
    `last_contact` DATETIME,
    `referral_id` INTEGER,
    `status_id` INTEGER DEFAULT 1,
    `contact_susccessful` BOOL,
    `offer_successful` BOOL,
    `reciept_successful` BOOL,
    `saved` BOOL DEFAULT 0,
    `coverletter_file` VARCHAR(255),
    `coverletter_type` VARCHAR(255),
    `coverletter_text` VARCHAR(255),
    `resume_file` VARCHAR(255),
    `resume_type` VARCHAR(255),
    `tracking_id` INTEGER NOT NULL,
    CONSTRAINT `PK_application` PRIMARY KEY (`application_id`)
) COMMENT = 'This table covers the recording of application for a position or responce to a job';

# ---------------------------------------------------------------------- #
# Add table "contact_type"                                               #
# ---------------------------------------------------------------------- #

CREATE TABLE `contact_type` (
    `contact_type_id` INTEGER NOT NULL AUTO_INCREMENT,
    `catagory` VARCHAR(40) NOT NULL,
    `title` VARCHAR(40) NOT NULL,
    `subject_line` VARCHAR(255),
    `email` TEXT,
    `default_name` VARCHAR(255),
    `default_email` VARCHAR(255),
    `system_email` BOOL,
    CONSTRAINT `PK_contact_type` PRIMARY KEY (`contact_type_id`)
) COMMENT = 'This table holds a list of email contact templates that can be used to send auto emails thought the system';
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (1, '1', 'Incomplete application', 'Your Resume is incomplete ', '<p>\r\n<meta content="text/html; charset=iso-8859-1" http-equiv="" />\r\n<table style="background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); margin: 0px; background-repeat: repeat-x; background-color: rgb(109,109,109)" height="100%" width="100%" border="0">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table cellspacing="0" cellpadding="5" width="451" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" bgcolor="#cccccc" height="30"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" bgcolor="#cccccc" height="30">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>Thank you for your recent application for the position of ##position## with Forever New.<br />\r\n                        <br />\r\n                        Unfortunately your application was incomplete. Could you please forward the following additional information:<br />\r\n                        <br />\r\n                        &laquo;xxxxxxxxxxxxxxxxxxxx&raquo;<br />\r\n                        <br />\r\n                        Once this additional information has been received, your application will be reviewed and I will advise you of the outcome once this has occurred.<br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to submit your application and thank you for considering&nbsp;Forever New&nbsp;as a prospective employer.<br />\r\n                        &nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30">\r\n                        <p class="style1"><b><span style="color: rgb(255,255,255)">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255,255,255)">Forever New Clothing is committed to protecting the personal information you provide to us. We will only use your personal information in order to provide a service to you. We will not share or sell this personal information with any other organisations. However, we may disclose personal information to our service providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255,255,255)">We will only use your personal information for the purpose it was intended. If you no longer wish to receive any information from us, please click on the ''unsubscribe'' link in the Subscribe section and your details will be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255,255,255)">We will provide you with access to any of your personal information we hold. If you require access to your personal information, please contact our Head Office on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>\r\n</p>\r\n<center></center>\r\n<p>&nbsp;</p>', 'Forever New ', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (2, '2', 'Interview invitation', 'Intervitation for an interview', '<p>\r\n<meta http-equiv="" content="text/html; charset=iso-8859-1">\r\n<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>We are pleased to invite you to an interview for the position of ##position## on &laquo;Date&raquo; at &laquo;time&raquo;.<br />\r\n                        <br />\r\n                        The interview will be held at &laquo;address&raquo;. <br />\r\n                        <br />\r\n                        Please email to confirm your attendance at this interview by &laquo;date&raquo;.<br />\r\n                        &nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>\r\n</meta>\r\n</p>\r\n<center></center>\r\n<p>&nbsp;</p>', 'Forever New ', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (3, '3', 'Blank email', '', '<p>\r\n<meta content="text/html; charset=iso-8859-1" http-equiv="">\r\n<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>\r\n</meta>\r\n</p>\r\n<center></center>\r\n<p>&nbsp;</p>', 'Forever new', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (4, '3', 'Delay', 'Sorry for the delay ', '<p>\r\n<meta http-equiv="" content="text/html; charset=iso-8859-1">\r\n<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;Thank you for your recent application for the position of ##position## with Forever New. Due to the high number of applications received for this role, the time needed to process all applications is considerable. We ask for your patience whist the selection process takes place.&nbsp; You will be informed of the outcome of your application in the near future.<br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to submit your application and thank you for considering Forever New as a prospective employer.<br />\r\n                        &nbsp;</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>\r\n</meta>\r\n</p>\r\n<center></center>\r\n<p>&nbsp;</p>', 'Forever new', 'reciutment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (5, '4', 'Application', '', '<p>\r\n<meta http-equiv="" content="text/html; charset=iso-8859-1">\r\n<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;Thank you for your recent application for the position of ##position## with Forever New.<br />\r\n                        <br />\r\n                        This position requires a particular combination of skills, experience and availability that best meet the needs of our organisation. On this occasion, I regret to advise that your application has been unsuccessful.<br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to prepare your application and wish you well in your search for employment.<br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>\r\n</meta>\r\n</p>\r\n<center></center>\r\n<p>&nbsp;</p>', 'Forever new', 'reciutment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (6, '4', 'Application withdrawn', 'Your application for ##position## at Forever New', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">Dear ##first## ##last##\r\n                        <p>Thank you for your application and for your interest in working at Forever New Clothing.</p>\r\n                        <p>At your request we have withdrawn your application.</p>\r\n                        <p>We appreciate your interest in Forever New and wish you the best of luck with your future endeavours. A copy of the Forever New Privacy Statement has also been attached for your information.</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever New ', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (7, '4', 'Blank rejection', '', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever New ', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (8, '4', 'Did not attend interview', 'You did not attend the interview', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;We recently invited you to participate in an interview, however you did not attend as requested.<br />\r\n                        <br />\r\n                        I regret to advise that we cannot finalise consideration of your application and that we are unable to offer you a position.<br />\r\n                        <br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information. <br />\r\n                        <br />\r\n                        I appreciate the time you have taken to prepare your application and wish you well in your search for employment.<br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.<br />\r\n                        &nbsp;</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'reciutment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (9, '4', 'Expression of Interest', 'Employment at Forever New ', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;Thank you for your recent expression of interest in employment with Forever New .<br />\r\n                        <br />\r\n                        We require a particular combination of skills, experience and availability that best meet the needs of our organisation. On this occasion, I regret to advise that your expression of interest has been unsuccessful.<br />\r\n                        <br />\r\n                        As your expression of interest contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to submit your expression of interest and wish you well in your search for employment.<br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'reciutment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (10, '4', 'Following interview', 'Interview for ##position## at Forever New ', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>Thank you for your recent application for the position of ##position## with Forever New and for your attendance at an interview.<br />\r\n                        <br />\r\n                        This position requires a particular combination of skills, experience and availability that best meet the needs of our organisation. On this occasion, I regret to advise that your application has been unsuccessful. <br />\r\n                        <br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to prepare your application and wish you well in your search for employment.<br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.<br />\r\n                        &nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (11, '4', 'Late Application', 'Thank you for your late application ', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>Thank you for your recent application for the position of ##position## with Forever New. Unfortunately your application was received after the closing date.&nbsp; The selection process has now progressed significantly since applications closed and therefore I am unable to accept your application on this particular occasion. <br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information. <br />\r\n                        <br />\r\n                        I appreciate the time you have taken to prepare your application and to participate in our selection process. I wish you well in your search for employment. <br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (12, '4', 'Not permitted to work', 'Sorry you are not permitted to work ', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>Thank you for your recent application for the position of ##position## with Forever New.<br />\r\n                        <br />\r\n                        On reviewing your application I have determined that you are not currently permitted to work in Australia. Consequently, I regret to advise that we are unable to offer you a position. Should you entitlement to work in Australia change you may wish to reapply for future vacancies as these occur.<br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to prepare your application and wish you well in your search for employment.<br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.<br />\r\n                        &nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (13, '5', 'Application', 'Application rejected', '<table style="background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); margin: 0px; background-repeat: repeat-x; background-color: rgb(109,109,109)" height="100%" width="100%" border="0">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table cellspacing="0" cellpadding="5" width="451" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" bgcolor="#cccccc" height="30"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" bgcolor="#cccccc" height="30">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        Thank you for your recent application for the position of ##position## with Forever New&nbsp; and for your &laquo; participation in our selection process/attendance at an interview&raquo;.<br />\r\n                        <br />\r\n                        You demonstrated a combination of skills, experience and availability that is suited to the needs of our organisation. However a suitable vacancy is not currently available. Should a suitable vacancy arise over the next three months that matches your availability, experience and preferences, I will contact you. Should a vacancy not arise in this time your details will be removed from our records. However you may reapply for vacancies in the future.<br />\r\n                        <br />\r\n                        As your application contains personal information about you a copy of the Forever New Privacy Statement which explains how this information will be used is outlined below for your information.<br />\r\n                        <br />\r\n                        I appreciate the time you have taken to prepare your application and to participate in our selection process.<br />\r\n                        <br />\r\n                        I wish you well in your search for employment.<br />\r\n                        <br />\r\n                        Thank you for considering Forever New as a prospective employer.<br />\r\n                        <br />\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30">\r\n                        <p class="style1"><b><span style="color: rgb(255,255,255)">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255,255,255)">Forever New Clothing is committed to protecting the personal information you provide to us. We will only use your personal information in order to provide a service to you. We will not share or sell this personal information with any other organisations. However, we may disclose personal information to our service providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255,255,255)">We will only use your personal information for the purpose it was intended. If you no longer wish to receive any information from us, please click on the ''unsubscribe'' link in the Subscribe section and your details will be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255,255,255)">We will provide you with access to any of your personal information we hold. If you require access to your personal information, please contact our Head Office on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (14, '5', 'Following unsuccessful interview', 'Application was unsecessful ', '<table height="100%" width="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td height="30" valign="top">\r\n                        <p class="style1"><b><span style="color: rgb(255, 255, 255);">Privacy Statement </span></b></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed. </span></p>\r\n                        <p class="style1"><span style="color: rgb(255, 255, 255);"> We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111. </span></p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com.au', NULL);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (15, '6', 'Expression of interest', 'Thank you for your interest', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0" style="font-size: 12px;">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p class="western" style="margin-bottom: 0in;">&nbsp;</p>\r\n                        <p class="western" style="margin-bottom: 0in;"><font face="Century Gothic, sans-serif">Dear </font>##first## ##last##</p>\r\n                        <p class="western" style="margin-bottom: 0in;">&nbsp;</p>\r\n                        Thank you for your recent expression of interest in working at Forever New.<br />\r\n                        <br />\r\n                        Your application will be kept on file for the next three months and should a suitable vacancy arise during this time we will be in contact with you. Should a vacancy not arise in this time your details will be removed from our records. However, we do encourage you to re-apply for vacancies in the future.<br />\r\n                        <br />\r\n                        Please see our Privacy Statement below which explains how the information in your expression of interest will be used and stored as per the privacy legislation.<br />\r\n                        <br />\r\n                        We appreciate the time you have taken to prepare your expression of interest and thank you for considering Forever New as a prospective employer.\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr style="color: rgb(255, 255, 255); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n                        <td valign="top" height="30">\r\n                        <p>Privacy Statement</p>\r\n                        <p>Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service.</p>\r\n                        <p>We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed.</p>\r\n                        <p>We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111.</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com', 0);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (16, '6', 'Email me job thank you ', 'Email me jobs has been recorded', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0" style="font-size: 12px;">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img alt="" src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p style="margin-bottom: 0in;" class="western">&nbsp;</p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Thank you for registering your details with us, and for your interest in working at Forever New.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We will keep you up to date by sending you an email as soon as we have listed a suitable role on our web site.  This way you will know about that perfect job before everyone else!</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">So stay tuned to your inbox and the Forever New website for new role openings!</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We appreciate your interest in Forever New and wish you the best of luck with your job search and future endeavours.</font>&nbsp;</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr style="color: rgb(255, 255, 255); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n                        <td valign="top" height="30">\r\n                        <p>Privacy Statement</p>\r\n                        <p>Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service.</p>\r\n                        <p>We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed.</p>\r\n                        <p>We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111.</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com', 0);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (17, '6', 'Application thank you message', 'Thank you for your Application', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109);">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p>Dear ##first## ##last##</p>\r\n                        <p class="western" style="margin-bottom: 0in;">Thank you for your interest in working at Forever New, your application has been successfully received for the position of ##position##.</p>\r\n                        <p class="western" style="margin-bottom: 0in;">We are presently moving through our recruitment process and will be in contact with you shortly.</p>\r\n                        <p class="western" style="margin-bottom: 0in;">Please see our Privacy Statement below which explains how the information in your application will be used and stored as per the privacy legislation.</p>\r\n                        <p class="western" style="margin-bottom: 0in;">We appreciate the time you have taken to prepare your application and thank you for considering Forever New as a prospective employer.</p>\r\n                        <p>Kind regards,</p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30">\r\n                        <p class="style1">Privacy Statement</p>\r\n                        <p class="style1">Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service.</p>\r\n                        <p class="style1">We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed.</p>\r\n                        <p class="style1">We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111.</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com', 0);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (18, '6', 'EOI 6 week', 'EOI 6 week', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0" style="font-size: 12px;">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p class="western" style="margin-bottom: 0in;">&nbsp;</p>\r\n                        <p class="western" style="margin-bottom: 0in;"><font face="Century Gothic, sans-serif">Dear </font>##first## ##last##</p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We haven&rsquo;t forgotten about you! Your expression of interest is still on file at Forever New.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Unfortunately a suitable position has not become available as yet, but with the success and growth of Forever New, you never know what may be around the corner!</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We will keep your application on file for another six weeks, and should a suitable position arise &ndash; we will be in contact with you.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Should a vacancy not arise in this time your details will be removed from our records. However, we do encourage you to reapply for vacancies in the future.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Please see our Privacy Statement below which explains how the information in your expression of interest will be used and stored as per the privacy legislation.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We appreciate the time you have taken to prepare your expression of interest and thank you for considering Forever New as a prospective employer.</font></p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr style="color: rgb(255, 255, 255); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n                        <td valign="top" height="30">\r\n                        <p>Privacy Statement</p>\r\n                        <p>Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service.</p>\r\n                        <p>We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed.</p>\r\n                        <p>We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111.</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com', 0);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (19, '6', 'EOI 11 week', 'EOI 11 week', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0" style="font-size: 12px;">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p class="western" style="margin-bottom: 0in;">&nbsp;</p>\r\n                        <p class="western" style="margin-bottom: 0in;"><font face="Century Gothic, sans-serif">Dear </font>##first## ##last##</p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Thank you for having your expression of interest on file at Forever New.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Unfortunately a suitable position has not become available as yet; so your application will shortly be removed from our records - but the right role may be just around the corner! </font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Should you still be looking for a suitable position - we&rsquo;d love to hear from you!  </font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We encourage you to visit our website and re-apply for vacancies in the future. Also, by completing another expression of interest application; you can make sure your application is ready to go and on file for another 3 months.   </font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We appreciate the time you have taken to prepare your expression of interest and thank you for considering Forever New as a prospective employer.</font></p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr style="color: rgb(255, 255, 255); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n                        <td valign="top" height="30">\r\n                        <p>Privacy Statement</p>\r\n                        <p>Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service.</p>\r\n                        <p>We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed.</p>\r\n                        <p>We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111.</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com', 0);
INSERT INTO `rec_contact_type` (`contact_type_id`, `catagory`, `title`, `subject_line`, `email`, `default_name`, `default_email`, `system_email`) VALUES (20, '6', 'Copy to another job', 'Thank you for your interest', '<table width="100%" height="100%" border="0" style="margin: 0px; background-image: url(http://www.sussan.com.au/email_images/spring/background.jpg); background-repeat: repeat-x; background-color: rgb(109, 109, 109); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n    <tbody>\r\n        <tr>\r\n            <td valign="top">&nbsp;</td>\r\n        </tr>\r\n        <tr>\r\n            <td valign="top" align="center">\r\n            <table width="451" cellspacing="0" cellpadding="5" border="0" style="font-size: 12px;">\r\n                <tbody>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc"><img src="http://www.forevernew.com.au/sites/all/themes/forevernew/images/logo.png" alt="" /></td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td valign="top" height="30" bgcolor="#cccccc">\r\n                        <p class="western" style="margin-bottom: 0in;">&nbsp;</p>\r\n                        <p class="western" style="margin-bottom: 0in;"><font face="Century Gothic, sans-serif">Dear </font>##first## ##last##</p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Thank you for your application and your interest in working at Forever New.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We have noticed your skills and experience are a great match for the position of ##position## which is a current vacancy at Forever New. </font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We would like to take your application into consideration for this role and have submitted it on your behalf, as you have indicated your preference for consideration for other vacancies.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We are presently moving through our recruitment process and will be in contact with you shortly. </font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">Please see our Privacy Statement below which explains how the information in your application will be used and stored as per the privacy legislation.</font></p>\r\n                        <p style="margin-bottom: 0in;" class="western"><font face="Century Gothic, sans-serif">We appreciate the time you have taken to prepare your application and thank you for considering Forever New as a prospective employer.</font></p>\r\n                        <p>HR<br />\r\n                        Forever New</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr style="color: rgb(255, 255, 255); font-family: Arial,Verdana,sans-serif; font-size: 12px;">\r\n                        <td valign="top" height="30">\r\n                        <p>Privacy Statement</p>\r\n                        <p>Forever New Clothing is committed to protecting                         		the personal information you provide to us. We will                         		only use your personal information in order to provide                         		a service to you. We will not share or sell this personal                         		information with any other organisations. However,                         		we may disclose personal information to our service                         		providers who assist in providing a service.</p>\r\n                        <p>We will only use your personal information for the                         		purpose it was intended. If you no longer wish to receive                         		any information from us, please click on the ''unsubscribe''                         		link in the Subscribe section and your details will                         		be removed.</p>\r\n                        <p>We will provide you with access to any of your personal                         		information we hold. If you require access to your                         		personal information, please contact our Head Office                         		on 03 9859 9111.</p>\r\n                        <p>&nbsp;</p>\r\n                        </td>\r\n                    </tr>\r\n                </tbody>\r\n            </table>\r\n            </td>\r\n        </tr>\r\n    </tbody>\r\n</table>', 'Forever new', 'recuitment@forevernew.com', 0);

# ---------------------------------------------------------------------- #
# Add table "referral"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `referral` (
    `referral_id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40),
    `cost` DOUBLE,
    CONSTRAINT `PK_referral` PRIMARY KEY (`referral_id`)
);
INSERT INTO rec_referral (`name`, `cost`)VALUES
('Forever New Website', '0'),
('Seek', '300.00'),
('Newspaper', '300.00'),
('Store', '0.00'),
('Employee Referral Program', '100.00'),
('Other', '0');

# ---------------------------------------------------------------------- #
# Add table "application_status"                                         #
# ---------------------------------------------------------------------- #

CREATE TABLE `application_status` (
    `status_id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    `sort` INTEGER NOT NULL,
    CONSTRAINT `PK_application_status` PRIMARY KEY (`status_id`)
) COMMENT = 'This table is a list of the type of status available to apply to an applicant';
INSERT INTO rec_application_status (name, sort) values
('New',1),
('Undecided',2),
('Shortlist',3),
('Phone Screen',4),
('Interview',5),
('Reference check',6),
('Unsuccessful',7),
('Successful',8),
('Application Withdrawn',9);

# ---------------------------------------------------------------------- #
# Add table "question_catagory"                                          #
# ---------------------------------------------------------------------- #

CREATE TABLE `question_catagory` (
    `question_catagory_id` INTEGER NOT NULL AUTO_INCREMENT,
    `question_catagory_name` INTEGER,
    CONSTRAINT `PK_question_catagory` PRIMARY KEY (`question_catagory_id`)
);

# ---------------------------------------------------------------------- #
# Add table "template"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `template` (
    `template_id` BIGINT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255),
    `employmenttype_id` INTEGER,
    `catagory_id` INTEGER NOT NULL,
    `office_id` INTEGER NOT NULL,
    `dept_id` INTEGER NOT NULL,
    `role_id` INTEGER,
    `state_id` INTEGER,
    `storeLoc_id` INTEGER COMMENT 'Recordes id for store location ',
    `start_date` DATE,
    `end_date` DATE,
    `discription` TEXT,
    `requirments` TEXT,
    `status` VARCHAR(40),
    `tracking_id` INTEGER NOT NULL,
    `advertisement_id` INTEGER NOT NULL,
    `create_date` DATETIME,
    `modify_date` DATETIME,
    `delete_date` DATETIME,
    CONSTRAINT `PK_template` PRIMARY KEY (`template_id`)
);

# ---------------------------------------------------------------------- #
# Add table "template_question"                                          #
# ---------------------------------------------------------------------- #

CREATE TABLE `template_question` (
    `template_id` BIGINT NOT NULL,
    `question_id` INTEGER NOT NULL,
    `sort` BIGINT,
    `tracking_id` INTEGER NOT NULL,
    `advertisement_id` INTEGER NOT NULL,
    CONSTRAINT `PK_template_question` PRIMARY KEY (`template_id`, `question_id`, `tracking_id`, `advertisement_id`)
);

CREATE INDEX `IDX_rec_template_question_1` ON `template_question` (`template_id`,`question_id`);

# ---------------------------------------------------------------------- #
# Add table "applicantion_notes"                                         #
# ---------------------------------------------------------------------- #

CREATE TABLE `applicantion_notes` (
    `notes_id` BIGINT NOT NULL AUTO_INCREMENT,
    `application_id` BIGINT,
    `applicant_id` BIGINT,
    `note` TEXT,
    `create_date` VARCHAR(40),
    `admin` VARCHAR(40),
    CONSTRAINT `PK_applicantion_notes` PRIMARY KEY (`notes_id`)
) COMMENT = 'This table is used to keeps notes on a particular job applicant for multiple applications';

# ---------------------------------------------------------------------- #
# Add table "users"                                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE `users` (
    `user_id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Primary Key for the users table, does not use auto increament, as we define the key based on the matching user id in the ps_admin.users table',
    `username` VARCHAR(40) NOT NULL COMMENT 'The login users name ',
    `password` VARCHAR(40) NOT NULL COMMENT 'the password for the user',
    `name` VARCHAR(40) NOT NULL COMMENT 'The firstname of the user',
    `surname` VARCHAR(40) COMMENT 'the surname of the user',
    `email` VARCHAR(40) NOT NULL COMMENT 'the email addess of the user ',
    `active` BOOL DEFAULT 1 COMMENT 'An active flag, that can turn on or off this user from the system',
    `last_login` DATETIME COMMENT 'A time stamp of the last tie this user logged in ',
    `division_id` INTEGER NOT NULL COMMENT 'key field to the division table',
    `administration_id` INTEGER NOT NULL COMMENT 'key field to the administration table',
    `create_date` DATETIME COMMENT 'row create date',
    `modify_date` DATETIME COMMENT 'row modified date',
    `delete_date` DATETIME COMMENT 'row delete date',
    CONSTRAINT `PK_users` PRIMARY KEY (`user_id`, `division_id`, `administration_id`)
) COMMENT = 'Users table listing all the users within the system';
INSERT INTO `rec_admin` ( `username` , `password` , `name` , `email` , `level` )
VALUES (
 'full admin', 'fa', 'Full Admin', 'jstewart@neopurple.com', '1'
), (
 'state admin', 'sa', 'State Admin', 'jstewart@neopurple.com', '2'
),(
 'business admin', 'ba', 'Business Admin', 'jstewart@neopurple.com', '3'
);

# ---------------------------------------------------------------------- #
# Add table "storerole"                                                  #
# ---------------------------------------------------------------------- #

CREATE TABLE `storerole` (
    `storerole_id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(40),
    CONSTRAINT `PK_storerole` PRIMARY KEY (`storerole_id`)
);
INSERT INTO rec_storerole (storerole_id, name) VALUES 
(1, 'Store Manager'),
(2, 'Assistant Store Manager'),
(3, 'Accessory Manager'),
(4, 'Sales Assistant'),
(5, 'Visual Merchandiser'),
(6, 'Stock Room Manager'),
(7, 'Stock Room Assistant');

# ---------------------------------------------------------------------- #
# Add table "referral_cost"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `referral_cost` (
    `referal_cost_id` INTEGER NOT NULL AUTO_INCREMENT,
    `advertisement_id` INTEGER NOT NULL,
    `referral_id` INTEGER,
    `value` INTEGER,
    `application_id` INTEGER NOT NULL,
    `question_id` INTEGER NOT NULL,
    `multi_id` INTEGER NOT NULL,
    CONSTRAINT `PK_referral_cost` PRIMARY KEY (`referal_cost_id`, `application_id`, `question_id`, `multi_id`)
);

# ---------------------------------------------------------------------- #
# Add table "division"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `division` (
    `division_id` INTEGER NOT NULL AUTO_INCREMENT COMMENT 'The Division key for the divisions table ',
    `name` VARCHAR(40) COMMENT 'the name of the division ',
    `description` VARCHAR(40) COMMENT 'A short discription of the division',
    `create_date` DATETIME COMMENT 'row create date ',
    `modify_date` DATETIME COMMENT 'row modified date',
    `delete_date` DATETIME COMMENT 'row delete date ',
    CONSTRAINT `PK_division` PRIMARY KEY (`division_id`)
) COMMENT = 'This table shows the type of division are available for this client, Devisions allow use you limit control of which users can see or edit which type of postions';

# ---------------------------------------------------------------------- #
# Add table "administration"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `administration` (
    `administration_id` INTEGER NOT NULL COMMENT 'primary id for the table',
    `group_name` VARCHAR(40) COMMENT 'The group name for the administrators',
    `create_advert` BOOL COMMENT 'can a user create an advertisment',
    `edit_advert` BOOL COMMENT 'can a user edit an advertisment',
    `remove_advert` BOOL COMMENT 'can a user remove an advertisment',
    `create_template` BOOL COMMENT 'can a user create a template',
    `edit_template` BOOL COMMENT 'can a user edit a template',
    `remove_template` BOOL COMMENT 'can a user remove a template',
    `add_user` BOOL COMMENT 'can a user add a user ',
    `edit_user` BOOL COMMENT 'can a user edit a user ',
    `delete_user` BOOL COMMENT 'can a user delete a user ',
    `edit_status` BOOL COMMENT 'can a user edit entrys in the status table ',
    `edit_referral` BOOL COMMENT 'can a user edit entrys in the referral table ',
    CONSTRAINT `PK_administration` PRIMARY KEY (`administration_id`)
) COMMENT = 'This table shows the type of administration privliages a group of admnistrators can have for editing or creating information';

# ---------------------------------------------------------------------- #
# Add table "employmenttype"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `employmenttype` (
    `employmenttype_id` INTEGER NOT NULL AUTO_INCREMENT,
    `employmenttype` VARCHAR(40),
    `create_date` DATETIME,
    `modify_date` DATETIME,
    `delete_date` DATETIME,
    CONSTRAINT `PK_employmenttype` PRIMARY KEY (`employmenttype_id`)
);

# ---------------------------------------------------------------------- #
# Foreign key constraints                                                #
# ---------------------------------------------------------------------- #

ALTER TABLE `advertisement` ADD CONSTRAINT `role_advertisement` 
    FOREIGN KEY (`role_id`, `dept_id`, `office_id`) REFERENCES `role` (`role_id`,`dept_id`,`office_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `category_advertisement` 
    FOREIGN KEY (`catagory_id`) REFERENCES `category` (`catagory_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `office_advertisement` 
    FOREIGN KEY (`office_id`) REFERENCES `office` (`office_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `department_advertisement` 
    FOREIGN KEY (`dept_id`, `office_id`) REFERENCES `department` (`dept_id`,`office_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `state_advertisement` 
    FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `store_advertisement` 
    FOREIGN KEY (`store_location_id`, `state_id`) REFERENCES `store` (`store_location_id`,`state_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `advertisement_question_advertisement` 
    FOREIGN KEY (`advertisement_id`) REFERENCES `advertisement_question` (`advertisement_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `storerole_advertisement` 
    FOREIGN KEY (`storerole_id`) REFERENCES `storerole` (`storerole_id`);

ALTER TABLE `advertisement` ADD CONSTRAINT `questionTracking_advertisement` 
    FOREIGN KEY (`advertisement_id`) REFERENCES `questionTracking` (`advertisement_id`);

ALTER TABLE `department` ADD CONSTRAINT `office_department_department` 
    FOREIGN KEY (`dept_id`, `office_id`) REFERENCES `office_department` (`dept_id`,`office_id`);

ALTER TABLE `role` ADD CONSTRAINT `department_role` 
    FOREIGN KEY (`dept_id`, `office_id`) REFERENCES `department` (`dept_id`,`office_id`);

ALTER TABLE `store` ADD CONSTRAINT `state_store` 
    FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`);

ALTER TABLE `question` ADD CONSTRAINT `question_multi_question` 
    FOREIGN KEY (`question_id`) REFERENCES `question_multi` (`question_id`);

ALTER TABLE `question` ADD CONSTRAINT `advertisement_question_question` 
    FOREIGN KEY (`question_id`) REFERENCES `advertisement_question` (`question_id`);

ALTER TABLE `question` ADD CONSTRAINT `question_catagory_question` 
    FOREIGN KEY (`question_catagory_id`) REFERENCES `question_catagory` (`question_catagory_id`);

ALTER TABLE `question` ADD CONSTRAINT `questionTracking_question` 
    FOREIGN KEY (`advertisement_id`) REFERENCES `questionTracking` (`advertisement_id`);

ALTER TABLE `applications_question` ADD CONSTRAINT `question_applications_question` 
    FOREIGN KEY (`question_id`, `advertisement_id`) REFERENCES `question` (`question_id`,`advertisement_id`);

ALTER TABLE `office_department` ADD CONSTRAINT `office_office_department` 
    FOREIGN KEY (`office_id`) REFERENCES `office` (`office_id`);

ALTER TABLE `application` ADD CONSTRAINT `applications_question_application` 
    FOREIGN KEY (`application_id`, `tracking_id`, `advertisement_id`) REFERENCES `applications_question` (`application_id`,`tracking_id`,`advertisement_id`);

ALTER TABLE `application` ADD CONSTRAINT `advertisement_application` 
    FOREIGN KEY (`advertisement_id`, `catagory_id`) REFERENCES `advertisement` (`advertisement_id`,`catagory_id`);

ALTER TABLE `application` ADD CONSTRAINT `referral_application` 
    FOREIGN KEY (`referral_id`) REFERENCES `referral` (`referral_id`);

ALTER TABLE `application` ADD CONSTRAINT `contact_type_application` 
    FOREIGN KEY (`contact_type_id`) REFERENCES `contact_type` (`contact_type_id`);

ALTER TABLE `application` ADD CONSTRAINT `application_status_application` 
    FOREIGN KEY (`status_id`) REFERENCES `application_status` (`status_id`);

ALTER TABLE `application` ADD CONSTRAINT `applicants_application` 
    FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`applicant_id`);

ALTER TABLE `template` ADD CONSTRAINT `template_question_template` 
    FOREIGN KEY (`template_id`, `tracking_id`, `advertisement_id`) REFERENCES `template_question` (`template_id`,`tracking_id`,`advertisement_id`);

ALTER TABLE `template` ADD CONSTRAINT `category_template` 
    FOREIGN KEY (`catagory_id`) REFERENCES `category` (`catagory_id`);

ALTER TABLE `template` ADD CONSTRAINT `state_template` 
    FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`);

ALTER TABLE `template` ADD CONSTRAINT `office_template` 
    FOREIGN KEY (`office_id`) REFERENCES `office` (`office_id`);

ALTER TABLE `template` ADD CONSTRAINT `role_template` 
    FOREIGN KEY (`role_id`, `dept_id`, `office_id`) REFERENCES `role` (`role_id`,`dept_id`,`office_id`);

ALTER TABLE `template` ADD CONSTRAINT `store_template` 
    FOREIGN KEY (`storeLoc_id`, `state_id`) REFERENCES `store` (`store_location_id`,`state_id`);

ALTER TABLE `template` ADD CONSTRAINT `department_template` 
    FOREIGN KEY (`dept_id`, `office_id`) REFERENCES `department` (`dept_id`,`office_id`);

ALTER TABLE `template_question` ADD CONSTRAINT `question_template_question` 
    FOREIGN KEY (`question_id`, `advertisement_id`) REFERENCES `question` (`question_id`,`advertisement_id`);

ALTER TABLE `applicantion_notes` ADD CONSTRAINT `application_applicantion_notes` 
    FOREIGN KEY (`application_id`) REFERENCES `application` (`application_id`);

ALTER TABLE `applicantion_notes` ADD CONSTRAINT `applicants_applicantion_notes` 
    FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`applicant_id`);

ALTER TABLE `users` ADD CONSTRAINT `division_users` 
    FOREIGN KEY (`division_id`) REFERENCES `division` (`division_id`);

ALTER TABLE `users` ADD CONSTRAINT `administration_users` 
    FOREIGN KEY (`administration_id`) REFERENCES `administration` (`administration_id`);

ALTER TABLE `referral_cost` ADD CONSTRAINT `advertisement_referral_cost` 
    FOREIGN KEY (`advertisement_id`) REFERENCES `advertisement` (`advertisement_id`);

ALTER TABLE `referral_cost` ADD CONSTRAINT `referral_referral_cost` 
    FOREIGN KEY (`referral_id`) REFERENCES `referral` (`referral_id`);
