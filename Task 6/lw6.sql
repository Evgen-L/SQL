CREATE DATABASE pharmacy;
USE pharmacy

--#1 Add FK's
 ALTER TABLE production ADD
	 FOREIGN KEY (id_company)
	 REFERENCES company(id_company)

 ALTER TABLE production ADD
	 FOREIGN KEY (id_medicine)
	 REFERENCES medicine(id_medicine)

ALTER TABLE dealer ADD
	 FOREIGN KEY (id_company)
	 REFERENCES company(id_company)

ALTER TABLE [order] ADD
	 FOREIGN KEY (id_production)
	 REFERENCES production(id_production)

ALTER TABLE [order] ADD
	 FOREIGN KEY (id_dealer)
	 REFERENCES dealer(id_dealer)

ALTER TABLE [order] ADD
	 FOREIGN KEY (id_pharmacy)
	 REFERENCES pharmacy(id_pharmacy)


--#2 Issue information on all orders of the medicine "Corderon" of the Company "Argus" indicating the names of pharmacies, dates, volumes of orders "
SELECT pharmacy.name AS pharmacy, [order].date, [order].quantity
FROM [order] 
JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
JOIN production ON [order].id_production = production.id_production
JOIN medicine ON production.id_medicine = medicine.id_medicine
JOIN company ON production.id_company = company.id_company
WHERE (company.name = 'Аргус') AND (medicine.name = 'Кордерон')


--#3 Provide a list of Pharma medicines, for which orders were not made until January 25.
SELECT medicine.name AS medicine
FROM medicine
WHERE medicine.name NOT IN (SELECT medicine.name
							FROM [order] 
							JOIN production ON [order].id_production = production.id_production
							JOIN medicine ON production.id_medicine = medicine.id_medicine
							JOIN company ON production.id_company = company.id_company
							WHERE (company.name = 'Фарма') AND ([order].date < '2019-01-25') )
							

--#4 Give the minimum and maximum scores for drugs to each company that has placed at least 120 orders
SELECT dealer.name, MAX(production.rating) AS max_mark, MIN(production.rating) AS min_mark
FROM [order]
JOIN production ON [order].id_production = production.id_production
JOIN medicine ON production.id_medicine = medicine.id_medicine
JOIN dealer ON [order].id_dealer = dealer.id_dealer
WHERE [order].id_dealer  IN (SELECT [order].id_dealer
							FROM [order] 
							GROUP BY [order].id_dealer
							HAVING COUNT([order].id_production) >= 120
							)
GROUP BY dealer.name

--#5 Provide lists of pharmacies that have made orders for all dealers of the AstraZeneca company. If the dealer has no orders, put NULL in the name of the pharmacy.
SELECT pharmacy.name AS pharmacy
FROM [order] 
JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
JOIN dealer ON [order].id_dealer = dealer.id_dealer
JOIN company ON dealer.id_company = company.id_company
WHERE company.name = 'AstraZeneca'

--#6 Reduce the cost of all drugs by 20% if it exceeds 3000, and the duration of treatment is no more than 7 days.
SELECT medicine.name AS medicine, production.price, medicine.cure_duration
FROM production 
JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE (production.price > 3000) AND (medicine.cure_duration  > 7)
ORDER BY medicine.name

UPDATE production
SET production.price = production.price - (production.price/100 * 20)
WHERE (production.price > 3000) AND production.id_medicine IN (SELECT id_medicine
                                                               FROM medicine
															   WHERE medicine.cure_duration  > 7)

--#7 Add to required indexes.
--medicine
CREATE NONCLUSTERED INDEX [IX_medicine_cure_duration] ON
[medicine]
(
   [cure_duration] ASC
)
INCLUDE ([name])

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON
[medicine]
(
   [name] ASC
)
INCLUDE ([cure_duration])

--company
CREATE NONCLUSTERED INDEX [IX_company_name] ON
[company]
(
   [name] ASC
)
INCLUDE ([established])

CREATE NONCLUSTERED INDEX [IX_company_established] ON
[company]
(
   [established] ASC
)
INCLUDE ([name])

--dealer
CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON
[dealer]
(
   [id_company] ASC
)
INCLUDE ([name], [phone])

--pharmacy
CREATE NONCLUSTERED INDEX [IX_pharmacy_rating] ON
[pharmacy]
(
   [rating] ASC
)
INCLUDE ([name])

--production
CREATE NONCLUSTERED INDEX [IX_production_price_rating] ON
[production]
(
   [price] ASC,
   [rating] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_price] ON
[production]
(
   [price] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_rating] ON
[production]
(
   [rating] ASC
)

--order
CREATE NONCLUSTERED INDEX [IX_order_date_quantity] ON
[order]
(
   [date] ASC,
   [quantity] ASC
)
INCLUDE (id_production, id_dealer, id_pharmacy)

CREATE NONCLUSTERED INDEX [IX_order_date] ON
[order]
(
   [date] ASC
)
INCLUDE (id_production, id_dealer, id_pharmacy)

CREATE NONCLUSTERED INDEX [IX_order_quantity] ON
[order]
(
   [quantity] ASC
)
INCLUDE (id_production, id_dealer, id_pharmacy)


--SELECT * FROM production
--SELECT * FROM [order]
--SELECT * FROM medicine
--SELECT * FROM dealer
--SELECT * FROM company
--SELECT * FROM pharmacy