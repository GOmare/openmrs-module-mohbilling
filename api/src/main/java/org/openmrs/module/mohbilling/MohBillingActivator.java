/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 * <p>
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * <p>
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.mohbilling;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Context;
import org.openmrs.module.BaseModuleActivator;
import org.openmrs.module.mohbilling.task.FlattenTableTask;
import org.openmrs.scheduler.SchedulerService;
import org.openmrs.scheduler.TaskDefinition;

/**
 * This class contains the logic that is run every time this module is either
 * started or shutdown
 */
public class MohBillingActivator extends BaseModuleActivator {

    protected Log log = LogFactory.getLog(this.getClass());

    /**
     * @see BaseModuleActivator#started()
     */
    public void started() {
        log.info("MoH-Billing Module started");

        String taskName = "Mamba - database Flattening Task";
        Long repeatInterval = 86400L; //second
        String taskClassName = FlattenTableTask.class.getName();
        String description = "MoH Mamba - ETL Task";

        addTask(taskName, taskClassName, repeatInterval, description);

    }

    /**
     * @see BaseModuleActivator#stopped()
     */
    public void stopped() {
        log.info("MoH-Billing Module stopped");
    }

    void addTask(String name, String className, Long repeatInterval, String description) {

        SchedulerService scheduler = Context.getSchedulerService();
        TaskDefinition taskDefinition = scheduler.getTaskByName(name);
        if (taskDefinition == null) {

            taskDefinition = new TaskDefinition(null, name, description, className);
            taskDefinition.setStartOnStartup(Boolean.TRUE);
            taskDefinition.setRepeatInterval(repeatInterval);
            scheduler.saveTaskDefinition(taskDefinition);
        }
    }

}
