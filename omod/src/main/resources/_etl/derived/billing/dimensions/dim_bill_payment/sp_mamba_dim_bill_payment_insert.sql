-- $BEGIN

INSERT INTO mamba_dim_department (dbill_payment_id,
                                  patient_bill_id,
                                  amount_paid,
                                  date_received,
                                  collector,
                                  created_date)
SELECT bill_payment_id,
       patient_bill_id,
       amount_paid,
       date_received,
       collector,
       created_date
FROM moh_bill_payment;

-- $END