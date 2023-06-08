-- $BEGIN
CREATE TABLE mamba_fact_insurance
(
    id             INT AUTO_INCREMENT,
    encounter_id   INT      NULL,
    client_id      INT      NULL,
    encounter_date DATETIME NULL,


    PRIMARY KEY (id)
);

CREATE INDEX mamba_fact_insurance_global_bill_id_index
    ON mamba_fact_insurance (global_bill_id);

CREATE INDEX mamba_fact_insurance_admission_id_index
    ON mamba_fact_insurance (admission_id);

CREATE INDEX mamba_fact_insurance_insurance_id_index
    ON mamba_fact_insurance (insurance_id);

CREATE INDEX mamba_fact_insurance_created_date_index
    ON mamba_fact_insurance (created_date);

CREATE INDEX mamba_fact_insurance_closed_index
    ON mamba_fact_insurance (closed);

CREATE INDEX mamba_fact_insurance_closing_date_index
    ON mamba_fact_insurance (closing_date);
-- $END

