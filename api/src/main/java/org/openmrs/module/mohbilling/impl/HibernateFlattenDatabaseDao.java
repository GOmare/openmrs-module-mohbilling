package org.openmrs.module.mohbilling.impl;

import org.openmrs.api.db.hibernate.DbSessionFactory;
import org.openmrs.module.mohbilling.dao.FlattenDatabaseDao;
import org.springframework.beans.factory.annotation.Autowired;

public class HibernateFlattenDatabaseDao implements FlattenDatabaseDao {

	@Autowired
	private DbSessionFactory sessionFactory;
	
	@Override
	public void executeFlatteningScript() {
		
		sessionFactory.getCurrentSession().createSQLQuery("CALL sp_data_processing_etl()").executeUpdate();
	}
	
	public DbSessionFactory getSessionFactory() {
		return sessionFactory;
	}
	
	public void setSessionFactory(DbSessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
}
