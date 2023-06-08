package org.openmrs.module.mohbilling.web.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.module.mohbilling.GlobalPropertyConfig;
import org.openmrs.module.mohbilling.businesslogic.FileExporter;
import org.openmrs.module.mohbilling.businesslogic.InsuranceUtil;
import org.openmrs.module.mohbilling.businesslogic.ReportsUtil;
import org.openmrs.module.mohbilling.model.*;
import org.openmrs.web.WebConstants;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.ParameterizableViewController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.*;

public class MohBillingInsuranceReportController extends
        ParameterizableViewController {
    protected final Log log = LogFactory.getLog(getClass());

    /* (non-Javadoc)
     * @see org.springframework.web.servlet.mvc.ParameterizableViewController#handleRequestInternal(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request,
                                                 HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(getViewName());

        if (request.getParameter("formStatus") != null
                && !request.getParameter("formStatus").equals("")) {

            String startDateStr = request.getParameter("startDate");
            String startHourStr = request.getParameter("startHour");
            String startMinStr = request.getParameter("startMinute");

            String endDateStr = request.getParameter("endDate");
            String endHourStr = request.getParameter("endHour");
            String endMinuteStr = request.getParameter("endMinute");

            String collectorStr = null;
            String insuranceStr = null;
            String thirdPartyStr = null;

            // parameters
            Object[] params = ReportsUtil.getReportParameters(request, startDateStr, startHourStr, startMinStr, endDateStr, endHourStr, endMinuteStr, collectorStr, insuranceStr, thirdPartyStr);

            Date startDate = (Date) params[0];
            Date endDate = (Date) params[1];

            Insurance insurance = InsuranceUtil.getInsurance(Integer.valueOf(request.getParameter("insuranceId")));//ok

            // get all consommation with globalbill closed
            List<GlobalBill> globalBills = ReportsUtil.getGlobalBills(startDate, endDate, insurance);
            System.out.println("Global Bill size: " + globalBills.size());
            List<AllServicesRevenue> allServicesRevenueList = new ArrayList<>();
            Set<String> columns = new HashSet<>();
            List<BigDecimal> totals = new ArrayList<BigDecimal>();
            Consommation initialConsommation = null;
            BigDecimal total100 = BigDecimal.ZERO;

            try {

                if (startDate != null && endDate != null) {

                    int countGlobalBill = 1;
                    for (GlobalBill aBill : globalBills) {

                        initialConsommation = ReportsUtil.getConsommationByGlobalBill(aBill);

                        if (aBill.isClosed()) {

                            List<PatientServiceBill> patientServiceBills = ReportsUtil.getAllItemsByGlobalBill(aBill);
                            List<HopService> reportColumns = GlobalPropertyConfig.getHospitalServiceByCategory("mohbilling.insuranceReportColumns");//ok
                            List<ServiceRevenue> serviceRevenueList = new ArrayList<ServiceRevenue>();

                            for (HopService hopService : reportColumns) {
                                columns.add(hopService.getName());
                                serviceRevenueList.add(ReportsUtil.getServiceRevenues(patientServiceBills, hopService));//ok
                            }

                            ServiceRevenue imagingRevenue = ReportsUtil.getServiceRevenue(patientServiceBills, "mohbilling.IMAGING");//ok
                            serviceRevenueList.add(imagingRevenue);

                            ServiceRevenue proceduresRevenue = ReportsUtil.getServiceRevenue(patientServiceBills, "mohbilling.PROCEDURES");//ok
                            serviceRevenueList.add(proceduresRevenue);

                            BigDecimal globalBillAmount = ReportsUtil.getTotalByItems(patientServiceBills);

                            //populate asr
                            AllServicesRevenue servicesRevenue = new AllServicesRevenue(BigDecimal.ZERO, BigDecimal.ZERO, "2016-09-11");
                            servicesRevenue.setRevenues(serviceRevenueList);
                            servicesRevenue.setAllDueAmounts(globalBillAmount);
                            servicesRevenue.setConsommation(initialConsommation);
                            allServicesRevenueList.add(servicesRevenue);

                            System.out.println("GlobalBill count Progress....: " + (countGlobalBill * 100) / globalBills.size() + "%");
                        }
                        countGlobalBill++;
                    }
                }

                List<PatientServiceBill> allItems = ReportsUtil.getBillItemsByAllGlobalBills(globalBills);
                for (String category : columns) {
                    totals.add(ReportsUtil.getTotalByCategorizedItems(allItems, category));//ok
                    total100 = total100.add(ReportsUtil.getTotalByCategorizedItems(allItems, category));//ok
                }

                totals.add(ReportsUtil.getTotalByCategorizedItems(allItems, GlobalPropertyConfig.getHospitalServiceByCategory("mohbilling.IMAGING")));//ok
                totals.add(ReportsUtil.getTotalByCategorizedItems(allItems, GlobalPropertyConfig.getHospitalServiceByCategory("mohbilling.PROCEDURES")));//ok

                total100 = total100.add(ReportsUtil.getTotalByCategorizedItems(allItems, GlobalPropertyConfig.getHospitalServiceByCategory("mohbilling.IMAGING")));//ok
                total100 = total100.add(ReportsUtil.getTotalByCategorizedItems(allItems, GlobalPropertyConfig.getHospitalServiceByCategory("mohbilling.PROCEDURES")));//ok

            } catch (Exception e) {
                request.getSession().setAttribute(WebConstants.OPENMRS_ERROR_ATTR,
                        "No patient bill found or service categories are not set properly. Contact System Admin... !");
                log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + e.getMessage());
            }

            if (!columns.contains("IMAGING")) {
                columns.add("IMAGING");
            }
            if (!columns.contains("PROCEDURES")) {
                columns.add("PROCED.");
            }

            request.getSession().setAttribute("columns", columns);
            request.getSession().setAttribute("listOfAllServicesRevenue", allServicesRevenueList);
            request.getSession().setAttribute("insurance", insurance);

            BigDecimal insuranceFlatFee = BigDecimal.ZERO;
            if (insurance.getCurrentRate().getFlatFee().compareTo(BigDecimal.ZERO) != 0) {
                insuranceFlatFee = insurance.getCurrentRate().getFlatFee();
            }

            mav.addObject("columns", columns);
            mav.addObject("totals", totals);
            mav.addObject("listOfAllServicesRevenue", allServicesRevenueList);
            mav.addObject("resultMsg", "[" + insurance.getName() + "] Bill from " + startDateStr + " To " + endDateStr);
            mav.addObject("insuranceFlatFee", insuranceFlatFee);

            mav.addObject("insuranceRate", insurance.getCurrentRate().getRate());
            mav.addObject("total100", total100);

        }
        mav.addObject("insurances", InsuranceUtil.getAllInsurances());//todo:nok

        if (request.getParameter("export") != null) {
            List<String> columns = (List<String>) request.getSession().getAttribute("columns");
            List<AllServicesRevenue> listOfAllServicesRevenue = (List<AllServicesRevenue>) request.getSession().getAttribute("listOfAllServicesRevenue");
            Insurance insurance = (Insurance) request.getSession().getAttribute("insurance");
            FileExporter.exportData(request, response, insurance, columns, listOfAllServicesRevenue);
        }
        return mav;
    }

}
