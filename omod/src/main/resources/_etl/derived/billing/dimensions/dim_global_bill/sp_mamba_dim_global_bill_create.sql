-- $BEGIN
CREATE TABLE IF NOT EXISTS mamba_dim_global_bill
(
    id              INT          NOT NULL AUTO_INCREMENT,
    global_bill_id  INT          NOT NULL,
    admission_id    int          not null,
    insurance_id    int          null,
    bill_identifier varchar(250) not null,
    global_amount   decimal      not null,
    closing_date    datetime     null,
    closed          smallint     not null,
    closed_by       int          null,
    closed_reason   varchar(150) null,
    edited_by       int          null,
    edit_reason     varchar(150) null,
    created_date    datetime     not null,

    PRIMARY KEY (id)
)
    CHARSET = UTF8MB4;

CREATE INDEX mamba_dim_global_bill_global_bill_id_index
    ON mamba_dim_global_bill (global_bill_id);

CREATE INDEX mamba_dim_global_bill_admission_id_index
    ON mamba_dim_global_bill (admission_id);

CREATE INDEX mamba_dim_global_bill_insurance_id_index
    ON mamba_dim_global_bill (insurance_id);

-- $END