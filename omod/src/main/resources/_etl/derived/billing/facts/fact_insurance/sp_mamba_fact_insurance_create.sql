-- $BEGIN
CREATE TABLE mamba_fact_insurance
(
    id                  INT          NOT NULL AUTO_INCREMENT,
    admission_date      DATETIME     NULL,
    closing_date        DATETIME     NULL,
    beneficiary_name    VARCHAR(255) NULL,
    household_head_name VARCHAR(255) NULL,
    family_code         VARCHAR(255) NULL,
    level               INT          NULL,
    card_number         VARCHAR(255) NULL,
    company_name        VARCHAR(255) NULL,
    age                 INT          NULL,
    birth_date          DATETIME     NULL,
    gender              CHAR(1)      NULL,
    doctor_name         VARCHAR(255) NULL,
    insurance_name      VARCHAR(255) NULL,

    PRIMARY KEY (id)
);
-- $END

