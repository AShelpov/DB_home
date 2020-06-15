USE graduate_db;

DESC debtors_individuals ;
ALTER TABLE debtors_individuals 
	ADD CONSTRAINT debtor_individuals__type_of_debtor_fk FOREIGN KEY (type_of_debtor) REFERENCES type_of_debtor(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT debtor_individuals__regions_fk FOREIGN KEY(region_of_bancrupcy_case) REFERENCES regions(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;

DESC records_of_compensation_fund ;
ALTER TABLE records_of_compensation_fund 
	ADD CONSTRAINT records_of_compensation_fund__union_id_fk FOREIGN KEY (id_of_union) REFERENCES self_regulating_union(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT records_of_compensation_fund__type_of_cf_record_id_fk FOREIGN KEY (type_of_record) REFERENCES type_of_cf_record(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;
		
DESC debtors_organisations ;
ALTER TABLE debtors_organisations 
	ADD CONSTRAINT debtors_organisations__regions_id_fk FOREIGN KEY (region_of_debtor) REFERENCES regions(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT debtors_organisations__type_of_debtor_id_fk FOREIGN KEY (type_of_debtor) REFERENCES type_of_debtor(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT debtors_organisations__type_of_organisation_form_id_fk FOREIGN KEY (type_of_organisation_form) REFERENCES type_of_organisation_form(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;
		
DESC members_of_unions ;
ALTER TABLE members_of_unions 
	ADD CONSTRAINT members_of_unions__self_regulating_union_id_fk FOREIGN KEY (id_of_union) REFERENCES self_regulating_union(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT members_of_unions__bancrupcy_manager_id_fk FOREIGN KEY (id_of_member) REFERENCES bancrupcy_manager(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT members_of_unions__type_of_union_records_id_fk FOREIGN KEY (type_of_id_record) REFERENCES type_of_union_records(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;
		
DESC ceo_records ;
ALTER TABLE ceo_records 
	ADD CONSTRAINT ceo_records__chief_executive_officers_id_fk FOREIGN KEY (id_of_ceo) REFERENCES chief_executive_officers(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT ceo_records__self_regulating_unioin_id_fk FOREIGN KEY (id_of_union) REFERENCES self_regulating_union(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT ceo_records__type_of_ceo_records_id_fk FOREIGN KEY (type_id_of_record) REFERENCES type_of_ceo_records(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;
		


DESC messages;
ALTER TABLE messages 
	ADD CONSTRAINT messages__type_of_debtor_id_fk FOREIGN KEY (id_type_of_debtor) REFERENCES type_of_debtor(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT messages__bancrupcy_manager_id_fk FOREIGN KEY (id_of_bancrupcy_manager) REFERENCES bancrupcy_manager(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT messages__message_types_id_fk FOREIGN KEY (id_type_of_message) REFERENCES message_types(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;

DESC attached_files ;
ALTER TABLE attached_files 
	ADD CONSTRAINT attached_files__bancrupcy_manager_id_fk FOREIGN KEY (author_id) REFERENCES bancrupcy_manager(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	ADD CONSTRAINT attached_files__messages_id_fk FOREIGN KEY (message_id) REFERENCES messages(id)
		ON UPDATE CASCADE
		ON DELETE SET NULL;