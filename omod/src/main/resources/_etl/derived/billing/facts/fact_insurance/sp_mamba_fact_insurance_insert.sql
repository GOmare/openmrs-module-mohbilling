-- $BEGIN

INSERT INTO mamba_fact_insurance
    (SELECT DATE_FORMAT(gb.created_date, '%d/%m/%Y') AS admission_date,
            DATE_FORMAT(gb.closing_date, '%d/%m/%Y') AS closing_date,
            per.person_name_long                     AS beneficiary_name,
            ben.owner_name                           AS household_head_name,
            ben.owner_code                           AS family_code,
            ben.level                                AS level,
            isp.insurance_card_no                    AS card_number,
            ben.company                              AS company_name,
            per.age                                  AS age,
            DATE_FORMAT(per.birthdate, '%d/%m/%Y')   AS birth_date,
            per.gender                               AS gender,
            gb.closed_by_name                        AS doctor_name,
            ins.name                                 as insurance_name

     FROM mamba_dim_patient_service_bill psb
              INNER JOIN mamba_dim_consommation cons ON psb.consommation_id = cons.consommation_id
              INNER JOIN mamba_dim_global_bill gb on cons.global_bill_id = gb.global_bill_id
              INNER JOIN mamba_dim_department dep on cons.department_id = dep.department_id
              INNER JOIN mamba_dim_beneficiary ben on cons.beneficiary_id = ben.beneficiary_id
              INNER JOIN mamba_dim_patient_bill ptb on cons.patient_bill_id = ptb.patient_bill_id
              INNER JOIN mamba_dim_insurance_bill isb on cons.insurance_bill_id = isb.insurance_bill_id
              INNER JOIN mamba_dim_third_party_bill tpb on cons.third_party_bill_id = tpb.third_party_bill_id
              INNER JOIN mamba_dim_insurance_policy isp on ben.insurance_policy_id = isp.insurance_policy_id
              INNER JOIN mamba_dim_insurance ins ON ins.insurance_id = isp.insurance_id
              INNER JOIN mamba_dim_person per ON per.person_id = isp.owner
              INNER JOIN mamba_dim_third_party tpt ON tpt.third_party_id = isp.third_party_id
              INNER JOIN mamba_dim_billable_service bls on psb.billable_service_id = bls.billable_service_id
              INNER JOIN mamba_dim_service_category sct ON sct.service_category_id = bls.service_category_id
              INNER JOIN mamba_dim_facility_service_price fsp
                         ON fsp.facility_service_price_id = bls.facility_service_price_id
              INNER JOIN mamba_dim_person bps ON bps.person_id = ben.patient_id
              INNER JOIN mamba_dim_person_name psn ON bps.person_id = psn.person_id

          -- INNER JOIN mamba_dim_bill_payment bip on bip.patient_bill_id = ptb.patient_bill_id

     WHERE gb.closed = 1);
-- $END