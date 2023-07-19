-- $BEGIN
-- Update the current insurance rate for this insurance
UPDATE mamba_dim_insurance ins
SET ins.current_insurance_rate = COALESCE(
        (SELECT rate
         FROM mamba_dim_insurance_rate ir
         WHERE ir.insurance_id = ins.insurance_id
           AND (ir.retire_date IS NULL OR ir.retire_date > NOW())
         ORDER BY ir.retire_date ASC
         LIMIT 1),
        0 -- Default value when no active rate is found (you can change this to any default value)
    );
-- $END


WITH LatestInsuranceRates AS (SELECT ir.insurance_id,
                                     COALESCE(MAX(CASE
                                                      WHEN ir.retire_date IS NULL OR ir.retire_date > NOW()
                                                          THEN ir.rate END), 0)    AS latest_rate,
                                     COALESCE(MAX(CASE
                                                      WHEN ir.retire_date IS NULL OR ir.retire_date > NOW()
                                                          THEN ir.flatFee END), 0) AS latest_flat_fee
                              FROM mamba_dim_insurance_rate ir
                              GROUP BY ir.insurance_id)
UPDATE mamba_dim_insurance i
    JOIN LatestInsuranceRates lir ON i.insurance_id = lir.insurance_id
SET i.current_insurance_rate          = lir.latest_rate,
    i.current_insurance_rate_flat_fee = lir.latest_flat_fee;


SET @rate = (SELECT rate
             FROM mamba_dim_insurance_rate ir
                      inner join mamba_dim_insurance ins
                                 ON ir.insurance_id = ins.insurance_id
             WHERE (ir.retire_date IS NULL OR ir.retire_date > NOW())
             ORDER BY ir.retire_date ASC
             LIMIT 1);

UPDATE mamba_dim_insurance ins
SET ins.current_insurance_rate = COALESCE(
        (SELECT rate
         FROM mamba_dim_insurance_rate ir
         WHERE ir.insurance_id = ins.insurance_id
           AND (ir.retire_date IS NULL OR ir.retire_date > NOW())
         ORDER BY ir.retire_date ASC
         LIMIT 1),
        0 -- Default value when no active rate is found (you can change this to any default value)
    );
