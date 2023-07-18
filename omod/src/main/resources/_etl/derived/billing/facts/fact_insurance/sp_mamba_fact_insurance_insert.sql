-- $BEGIN

INSERT INTO mamba_fact_insurance
    (SELECT

         -- PATIENT_SERVICE_BILL
         psb.patient_service_bill_id,
         psb.consommation_id,
         psb.billable_service_id,
         psb.service_id,
         psb.service_date,
         psb.unit_price,
         psb.quantity,
         psb.paid_quantity,
         psb.service_other,
         psb.service_other_description,
         psb.is_paid,
         psb.drug_frequency,
         psb.item_type,
         psb.voided,

         -- CONSOMMATION
         cons.global_bill_id,
         cons.department_id,
         cons.beneficiary_id,
         cons.patient_bill_id,
         cons.insurance_bill_id,
         cons.third_party_bill_id,

         -- GLOBAL BILL
         gb.admission_id,
         gb.insurance_id,
         gb.bill_identifier,
         gb.global_amount,
         gb.closing_date,
         gb.closed,
         gb.closed_by,
         gb.closed_reason,
         gb.edited_by,
         gb.edit_reason,
         gb.created_date         AS global_bill_creation_date,

         -- DEPARTMENT
         dep.name                AS department_name,

         -- BILLABLE SERVICE
         bls.facility_service_price_id,
         bls.service_category_id,
         bls.maxima_to_pay,
         bls.start_date,
         bls.end_date,

         -- BENEFICIARY
         ben.patient_id          AS beneficary_patient_id,
         ben.insurance_policy_id,
         ben.policy_id_number,
         ben.creator,
         ben.owner_name,
         ben.owner_code,
         ben.level,
         ben.company,

         -- PATIENT BILL
         ptb.amount              AS patient_bill_amount,
         ptb.is_paid             AS is_patient_bill_paid,
         ptb.status,

         -- INSURANCE BILL
         isb.amount              AS insurance_bill_amount,

         -- THIRD PARTY BILL
         tpb.amount              AS third_party_bill_amount,

         -- INSURANCE POLICY
         isp.third_party_id,
         isp.insurance_card_no,
         isp.owner               AS insurance_policy_owner,
         isp.coverage_start_date,
         isp.expiration_date,

         -- INSURANCE
         ins.concept_id          AS insurance_company_concept,
         ins.category            AS insurance_category,
         ins.name                AS insurance_company_name,
         ins.address             AS insurance_company_address,
         ins.phone               AS insurance_company_phone,

         -- OWNER PATIENT
         per.person_id           AS owner_patient_id,

         -- THIRD PARTY
         tpt.name                AS third_party_name,
         tpt.rate                AS third_party_rate,

         -- SERVICE CATEGORY
         sct.name                AS service_category_name,
         sct.price               AS service_category_price,

         -- FACILITY SERVICE PRICE
         fsp.location_id         AS facility_location_id,
         fsp.concept_id          AS facility_concept_id,
         fsp.name                AS facility_name,
         fsp.full_price          AS facility_full_price,

         -- BENEFICIARY PATIENT
         bps.person_id           AS beneficiary_patient_id,
         psn.family_name         AS beneficiary_family_name,
         psn.middle_name         AS beneficiary_middle_name,
         psn.given_name          AS beneficiary_given_name,
         bps.birthdate           AS beneficiary_birth_date,
         bps.birthdate_estimated AS beneficiary_birth_date_estimated,
         bps.gender              AS beneficiary_gender

         -- BILL PAYMENT
         -- bip.bill_payment_id,
         -- bip.amount_paid,
         -- bip.date_received,
         -- bip.collector

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