-- $BEGIN
CREATE TABLE IF NOT EXISTS mamba_dim_insurance_rate
(
    id                INT            NOT NULL AUTO_INCREMENT,
    insurance_rate_id INT            NOT NULL,
    insurance_id      int            not null,
    rate              float          not null,
    flatFee           decimal(20, 2) null,
    start_date        date           not null,
    end_date          date           null,
    created_date      date           not null,

    PRIMARY KEY (id)
)
    CHARSET = UTF8MB4;

CREATE INDEX mamba_dim_insurance_rate_insurance_rate_id_index
    ON mamba_dim_insurance_rate (insurance_rate_id);

CREATE INDEX mamba_dim_insurance_rate_insurance_id_index
    ON mamba_dim_insurance_rate (insurance_id);

-- $END