USE graduate_db;

CREATE VIEW show_messages AS
	(SELECT * FROM 
		((SELECT mess.date_of_publication AS Дата_публикации_время_московское,
				 mt.mess_type AS Тип_сообщения,
				 CONCAT(di.first_name, " ", di.last_name, " ", di.patronimic) AS Должник,
				 di.place_of_living AS Адрес,
				 CONCAT(bc.first_name, " ", bc.last_name, " ", bc.patronimic) AS Кем_опубликовано
			FROM messages mess
				JOIN message_types mt
					ON mess.id_type_of_message = mt.id 
				JOIN type_of_debtor tod 
					ON mess.id_type_of_debtor = tod.id
				JOIN debtors_individuals di 
					ON mess.id_of_debtor = di.id 
				JOIN bancrupcy_manager bc 
					ON mess.id_of_bancrupcy_manager = bc.id 
			WHERE mess.id_type_of_debtor = 1)
		UNION 
		(SELECT  mess.date_of_publication AS Дата_публикации_время_московское,
				 mt.mess_type AS Тип_сообщения,
				 do.long_name AS Должник,
				 do.adress_of_debtor AS Адрес,
				 CONCAT(bc.first_name, " ", bc.last_name, " ", bc.patronimic) AS Кем_опубликовано
			FROM messages mess
				JOIN message_types mt
					ON mess.id_type_of_message = mt.id 
				JOIN type_of_debtor tod 
					ON mess.id_type_of_debtor = tod.id
				JOIN debtors_organisations do
					ON mess.id_of_debtor = do.id 
				JOIN bancrupcy_manager bc 
					ON mess.id_of_bancrupcy_manager = bc.id 
			WHERE mess.id_type_of_debtor = 2)) AS final_query
		ORDER BY Дата_публикации_время_московское DESC)
;

SELECT * FROM show_messages LIMIT 50;
-- I can estimate debtor in view
SELECT * FROM show_messages WHERE Должник = "Future-proofed analyzing forecast";


DROP VIEW show_full_messages_of_individuals ;
CREATE VIEW show_full_messages_of_individuals AS
	(SELECT mess.id AS №_сообщения,
		   mess.date_of_publication AS Дата_публикации,
		   CONCAT(di.first_name, " ", di.last_name, " ", di.patronimic ) AS ФИО_должника,
		   di.date_of_birth AS Дата_рождения,
		   di.place_of_birth AS Место_рождения,
		   di.place_of_living AS Место_жительства,
		   di.individual_tax_number AS ИНН,
		   di.personal_retirement_number AS СНИЛС,
		   CONCAT(bm.first_name, " ", 
		   		  bm.last_name, " ", 
		   		  bm.patronimic, " ", "(ИНН ",
		   		  bm.individual_tax_number, ", СНИЛС ",
		   		  bm.personal_retirement_number,")") AS Арбитражный_управляющий,
		   bm.email AS Адрес_для_корреспонденции,
		   mess.message_body AS Публикуемые_сведения
				FROM debtors_individuals di 
					LEFT JOIN messages mess 
						ON di.id = mess.id_of_debtor
					JOIN bancrupcy_manager bm 
						ON mess.id_of_bancrupcy_manager = bm.id 
		WHERE mess.id_type_of_debtor = 1)
;
SELECT * FROM show_full_messages_of_individuals WHERE №_сообщения = 2669;


CREATE VIEW show_full_messages_of_organisations AS
	(SELECT mess.id AS №_сообщения,
		   mess.date_of_publication AS Дата_публикации,
		   do.long_name AS Наименование_должника,
		   do.adress_of_debtor AS Адрес,
		   do.individual_registration_number AS ОГРН,
		   do.individual_tax_number AS ИНН,
		   CONCAT(bm.first_name, " ", 
			   		  bm.last_name, " ", 
			   		  bm.patronimic, " ", "(ИНН ",
			   		  bm.individual_tax_number, ", СНИЛС ",
			   		  bm.personal_retirement_number,")") AS Арбитражный_управляющий,
		  bm.email AS Адрес_для_корреспонденции,
		  mess.message_body AS Публикуемые_сведения
		   		FROM debtors_organisations do 
					LEFT JOIN messages mess 
						ON do.id = mess.id_of_debtor
					JOIN bancrupcy_manager bm 
						ON mess.id_of_bancrupcy_manager = bm.id 
				
				WHERE mess.id_type_of_debtor =2);

SELECT * FROM show_full_messages_of_organisations WHERE №_сообщения = 345;


CREATE VIEW show_debtors_organisations AS
	(SELECT tod.type_of_debtor AS Категория,
			toof.type_of_company AS Тип_категории,
			do.long_name AS Должник,
			do.individual_tax_number AS ИНН,
			do.individual_registration_number AS ОГРН,
			r.name AS Регион,
			do.adress_of_debtor AS Адрес
		FROM debtors_organisations do
			JOIN regions r 
				ON do.region_of_debtor = r.id 
			JOIN type_of_organisation_form toof 
				ON do.type_of_organisation_form = toof.id 
			JOIN type_of_debtor tod 
				ON do.type_of_debtor = tod.id)
;

SELECT * FROM show_debtors_organisations ;

-- With such view I can estimate region where max concentration of debtors organisations
SELECT Регион, 
	   COUNT(Регион) AS Количество_должников 
	   		FROM show_debtors_organisations 
	   GROUP BY Регион 
	   ORDER BY Количество_должников DESC;


-- Or what type of organisations having max debtors
SELECT Тип_категории,
	   COUNT(Тип_категории) AS Количество_должников
	   		FROM show_debtors_organisations 
	   GROUP BY Тип_категории
	   ORDER BY Количество_должников DESC;


CREATE VIEW show_debtors_individuals AS
	(SELECT tod.type_of_debtor AS Категория,
		   CONCAT(di.first_name, " ", di.last_name, " ", di.patronimic) AS Должник,
		   di.individual_tax_number AS ИНН,
		   di.personal_retirement_number AS СНИЛС,
		   r.name AS Регион,
		   di.place_of_living AS Адрес
		FROM debtors_individuals di
		 	JOIN type_of_debtor tod 
				ON di.type_of_debtor = tod.id 
			JOIN regions r 
				ON di.region_of_bancrupcy_case = r.id)
;

SELECT * FROM show_debtors_individuals ;

SELECT Регион, 
	   COUNT(Регион) AS Количество_должников 
	   		FROM show_debtors_organisations 
	   GROUP BY Регион 
	   ORDER BY Количество_должников DESC;
	   

-- Query 1
-- Count balance of compensation fund till now of self-regulating union on each date of changes
SELECT sru.name AS name_of_union,
	   sru.individual_registration_number  AS registration_number,
	   rocf.date_of_record AS date_of_changes,
	   rocf.amount AS amount_of_changes,
	   sum(rocf.amount) OVER(PARTITION BY rocf.id_of_union ORDER BY rocf.date_of_recor) AS balance_at_the_date 
	FROM records_of_compensation_fund rocf
		JOIN self_regulating_union sru 
			ON rocf.id_of_union = sru.id
	WHERE rocf.date_of_record < CURRENT_DATE()
	ORDER BY rocf.id_of_union, rocf.date_of_record


-- Query 2
-- Show CEO's history of each unions
SELECT  sru.name AS name_of_union,
		sru.individual_registration_number AS registration_number,
		ceo.full_name AS name_of_ceo,
		cr.date_of_record AS date_of_record,
		tocr.type_of_record AS type_of_record
	FROM ceo_records cr 
		JOIN chief_executive_officers ceo 
			ON cr.id_of_ceo = ceo.id 
		JOIN self_regulating_union sru 
			ON cr.id_of_union = sru.id
		JOIN type_of_ceo_records tocr 
			ON cr.type_id_of_record = tocr.id 
	WHERE cr.date_of_record < CURRENT_DATE()
	ORDER BY sru.individual_registration_number, cr.date_of_record 
;


-- Query 3
-- Count numbers of members in each union
SELECT sru.name AS name,
	   (enter_in_union - exit_from_union) AS total_number_of_members
	FROM
	(SELECT mou.id_of_union,
		   COUNT(mou.id) AS enter_in_union
			FROM members_of_unions mou
				JOIN type_of_union_records tour
					ON mou.type_of_id_record = tour.id 
			WHERE tour.type_of_record = "Включение в СРО"
			GROUP BY mou.id_of_union) AS enter_to
	JOIN 
	(SELECT mou.id_of_union,
		   COUNT(mou.id) AS exit_from_union
			FROM members_of_unions mou
				JOIN type_of_union_records tour
					ON mou.type_of_id_record = tour.id 
			WHERE tour.type_of_record = "Исключение из СРО"
			GROUP BY mou.id_of_union) AS exit_from
		ON enter_to.id_of_union = exit_from.id_of_union
	JOIN self_regulating_union sru 
		ON exit_from.id_of_union = sru.id 
;


-- Query 4
-- Count amount of bancrupcy cases in each region
SELECT final_query.region,
	   COUNT(final_query.message) AS total_bancrupcy_cases
			FROM
				((SELECT reg.name AS region,
					   mess.id AS message
							FROM messages mess
								JOIN message_types mt
									ON mess.id_type_of_message = mt.id
								JOIN debtors_individuals di 
									ON mess.id_of_debtor = di.id 
										JOIN regions reg 
									ON di.region_of_bancrupcy_case = reg.id
							WHERE mess.id_type_of_debtor = 1 AND mt.mess_type = "Начало исполнительного производства") 
				UNION
				(SELECT reg.name AS region,
					   mess.id AS message
							FROM messages mess
								JOIN message_types mt
									ON mess.id_type_of_message = mt.id
								JOIN debtors_organisations do 
									ON mess.id_of_debtor = do.id 
										JOIN regions reg 
									ON do.region_of_debtor = reg.id
							WHERE mess.id_type_of_debtor = 2 AND mt.mess_type = "Начало исполнительного производства") 
						) AS final_query
				GROUP BY final_query.region
				ORDER BY total_bancrupcy_cases DESC;
				

